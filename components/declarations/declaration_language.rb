class DeclarationLanguage < Declarations
  attr_reader :languages_table, :declarations_language, :subjects
  
  def initialize(params, logged_user, settings = false)
    super
    unless settings
      execute params
    else
      setup params
    end
  end
  
  def execute params
    @languages_table = [['---', ''], ['j. angielski', 'en'], ['j. polski', 'pl']]
    valid_languages = @languages_table[1..@languages_table.length].collect { |i| i[1] unless i[1].empty? }
    if params[:declarations_language]
      given_subjects = params[:declarations_language].sort.collect {|i| [i[0].gsub(/_[ab]/, ''), (valid_languages.include?(i[1]) ? i[1] : 'en')] }
      given_keys = Hash[*given_subjects.flatten].keys
      converted_subjects = {}
      given_keys.each { |key| given_subjects.each { |subject| converted_subjects[key] = converted_subjects[key].to_s + subject[1] if subject[0] == key } }
      merge_subjects converted_subjects
      @merged_subjects.each_pair do |subject, language|
        declarations_language = {
            :declaration_id => @declaration_id,
            :subject_id => subject.to_i,
            :user_id => @logged_user.id,
            :date => Time.now,
            :language => language,
        }
        create_or_update subject, declarations_language
      end
      @flash_notice = 'Deklaracja została zapisana'
    end
    if(declarations_language_filled = DeclarationsSubject.find(:all, :conditions => ['declaration_id = ? AND user_id = ?', @declaration_id, @logged_user.id]))
      @declarations_language = {}
      declarations_language_filled.each do |dlf|
        fill_selects dlf.subject_id, dlf.language
      end
      @declarations_language = HashWithMethods.new(@declarations_language)
    end
    @template = 'language'
  end
  
  def setup params
    @subjects = {}
    DeclarationsSubject.find(:all, :conditions => ['declaration_id = ? AND user_id IS NOT NULL', @declaration_id], :group => 'subject_id').collect {|i| {i.subject_id => Hash[*(DeclarationsSubject.count(:conditions => ['declaration_id = ? AND user_id IS NOT null AND subject_id = ?', @declaration_id, i.subject_id], :group => 'language').flatten)]} }.each {|value| @subjects = value.merge(@subjects)}
    @template = 'language'
  end

  def fill_selects subject, language
    @declarations_language[(IdEncoder.encode(subject) + '_a')] = language[0..1]
    @declarations_language[(IdEncoder.encode(subject) + '_b')] = language[2..3]
  end
  
end
