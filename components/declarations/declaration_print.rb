class DeclarationPrint < Declarations
  attr_reader :print_table, :declarations_print, :subjects
  
  def initialize(params, logged_user, settings = false)
    super
    unless settings
      execute params
    else
      setup params
    end
  end
  
  def execute params
    @print_table = [['nie', false], ['tak', true]]
    if params[:declarations_print]
      merge_subjects(params[:declarations_print]) {|subject| (subject == 'true')}
      @merged_subjects.each_pair do |subject, print|
        declarations_print = {
            :declaration_id => @declaration_id,
            :subject_id => subject.to_i,
            :user_id => @logged_user.id,
            :date => Time.now,
            :print => print
        }
        create_or_update subject, declarations_print
      end
      @flash_notice = 'Deklaracja została zapisana'
    end
    if(declarations_print_filled = DeclarationsSubject.find(:all, :conditions => ['declaration_id = ? AND user_id = ?', @declaration_id, @logged_user.id]))
      @declarations_print = {}
      declarations_print_filled.each do |dpf|
        @declarations_print[IdEncoder.encode(dpf.subject_id)] = dpf.print
      end
      @declarations_print = HashWithMethods.new(@declarations_print)
    end
    @template = 'print'
  end
  
  def setup params
    @subjects = Hash[*(DeclarationsSubject.count(:all, :conditions => ['declaration_id = ? AND user_id IS NOT NULL AND print = true', @declaration_id], :group => 'subject_id').flatten)]
    @template = 'print'
  end
  
end
