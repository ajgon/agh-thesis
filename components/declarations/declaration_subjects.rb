class DeclarationSubjects < Declarations
  attr_reader :subjects_limit, :declarations_subject, :subjects
  def initialize(params, logged_user, settings = false)
    super
    unless settings
      execute params
    else
      setup params
    end
  end
  
  def execute params
    @declarations_subjects = DeclarationsSubject.find(:all, :include => [:declaration, :subject], :conditions => ['declaration_id = ? AND speciality_id = ? AND user_id IS NULL', @declaration_id, @logged_user.users_student.speciality_id])
    @subjects_limit = Declaration.find_by_code(@declaration_code).how_many?(@logged_user.users_student.speciality_id)
    if params[:declarations_subject]
      params[:declarations_subject].delete_if {|key, value| value.to_i != 1}
      if params[:declarations_subject].length == @subjects_limit
        merge_subjects params[:declarations_subject]
        @merged_subjects.delete_if {|key, value| value.nil? }
        @merged_subjects.keys.each do |subject|
          declarations_subject = {
              :declaration_id => @declaration_id,
              :subject_id => subject.to_i,
              :user_id => @logged_user.id,
              :date => Time.now,
          }
          create_or_update subject, declarations_subject
        end
        if(declarations_subject_filled = DeclarationsSubject.find(:all, :conditions => ['declaration_id = ? AND user_id = ?', @declaration_id, @logged_user.id]))
          @declarations_subject = {}
          declarations_subject_filled.each do |dsf|
            @declarations_subject[IdEncoder.encode(dsf.subject_id)] = '1'
          end
          @declarations_subject = HashWithMethods.new(@declarations_subject)
        end
      end
    end
    @template = 'subjects'
  end
  
  def setup params
    @subjects = Hash[*(DeclarationsSubject.count(:all, :conditions => ['declaration_id = ? and user_id IS NOT NULL', @declaration_id], :group => 'subject_id').flatten)]
    @template = 'subjects'
  end
end
