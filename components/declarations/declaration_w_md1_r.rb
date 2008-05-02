class DeclarationWMd1R < Declarations
  attr_reader :average, :declarations_subject, :declarations_grade
  def initialize(params, logged_user)
    @declaration_code = 'WMd1R'
    super
    if params[:declarations_subject] and !params[:back] and !already_filled?
      merge_subjects(params[:declarations_grade]) {|grade| grade.to_f }
      @average = (@merged_subjects.values.sum / @merged_subjects.values.length).to_s[0..3]
      params[:declarations_subject][:module] = 'E' unless ['E', 'T'].include?(params[:declarations_subject][:module])
      params[:declarations_subject][:year] = Time.now.year - @logged_user.users_student.year - (Time.now.month > 9 ? 1 : 0) unless (1970..Time.now.year).include?(params[:declarations_subject][:year].to_i)
      if params[:final_commit]
        @merged_subjects.each_pair do |subject, grade|
          DeclarationsSubject.new({
            :declaration_id => @declaration_id,
            :subject_id => subject.to_i,
            :user_id => @logged_user.id,
            :grade => grade,
            :year => params[:declarations_subject][:year],
            :module => params[:declarations_subject][:module],
            :date => Time.now,
            :language => nil,
            :print => nil
          }).save
        end
        @template = 'deanery/declarations/WMd1R_done'
      else
        @template = 'deanery/declarations/WMd1R_1'
      end
    else
      @declarations_subject = HashWithMethods.new(params[:declarations_subject]) if params[:declarations_subject]
      @declarations_grade = HashWithMethods.new(params[:declarations_grade]) if params[:declarations_grade]
      unless already_filled?
        @template = 'deanery/declarations/' + params[:declaration][:code] if params[:declaration][:code]
      else
        @template = 'deanery/declarations/' + params[:declaration][:code] + '_done' if params[:declaration][:code]
      end
    end    
  end
end
