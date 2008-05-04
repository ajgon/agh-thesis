class DeclarationModule < Declarations
  attr_reader :average, :declarations_subject, :declarations_grade, :students, :fields
  def initialize(params, logged_user, settings = false)
    super
    if settings
      setup params
    else
      if params[:declarations_subject] and !params[:back] and !already_filled?
        merge_subjects(params[:declarations_grade]) {|grade| grade.to_f }
        @average = (@merged_subjects.values.sum / @merged_subjects.values.length).to_s[0..3]
        params[:declarations_subject][:module] = 2 unless [2, 3].include?(params[:declarations_subject][:module])
        params[:declarations_subject][:year] = Time.now.year - @logged_user.users_student.year - (Time.now.month > 9 ? 1 : 0) unless (1970..Time.now.year).include?(params[:declarations_subject][:year].to_i)
        if params[:final_commit]
          @merged_subjects.each_pair do |subject, grade|
            DeclarationsSubject.new({
              :declaration_id => @declaration_id,
              :subject_id => subject.to_i,
              :user_id => @logged_user.id,
              :grade => grade,
              :year => params[:declarations_subject][:year],
              :speciality_id => params[:declarations_subject][:module],
              :date => Time.now,
            }).save
          end
          @template = 'module_done'
        else
          @template = 'module_1'
        end
      else
        @declarations_subject = HashWithMethods.new(params[:declarations_subject]) if params[:declarations_subject]
        @declarations_grade = HashWithMethods.new(params[:declarations_grade]) if params[:declarations_grade]
        unless already_filled?
          @template = 'module'
        else
          @template = 'module_done'
        end
      end    
    end
  end
  
  def setup params
    if params[:page]
      user_id = DeclarationsSubject.find(IdEncoder.decode(params[:page])).user_id
      @declarations_subject = DeclarationsSubject.find(:all, :include => [:user, :subject], :conditions => ['declaration_id = ? AND user_id = ?', @declaration_id, user_id])
      declaration_subject = @declarations_subject.first
      @fields = HashWithMethods.new({
        :time => declaration_subject.date.to_s,
        :name => declaration_subject.user.firstname.upcase + '&nbsp;' + declaration_subject.user.lastname.upcase,
        :sindex => declaration_subject.user.users_student.sindex,
        :module => (declaration_subject.speciality_id == 2 ? 'Elektronika' : 'Telekomunikacja'),
        :year => declaration_subject.year,
        :grade => ((@declarations_subject.collect {|i| i.grade}).sum / (@declarations_subject.length.to_f)).to_s[0..3]
      })
      @template = 'module_1'
    else
      @students = []
      declarations = DeclarationsSubject.find(:all, :include => :user, :conditions => ['declaration_id = ? AND user_id IS NOT null', @declaration_id], :group => 'user_id')
      declarations.each do |declaration|
        @students.push(HashWithMethods.new({
              :code => IdEncoder.encode(declaration.id),
              :name => declaration.user.firstname + '&nbsp;' + declaration.user.lastname,
              :date => declaration.date
            }))
      end
      @template = 'module'
    end
  end
end
