class DeclarationWJd2Rz < Declarations
  attr_reader :languages_table, :declarations_language
  
  def initialize(params, logged_user)
    @declaration_code = 'WJd2Rz'
    super
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
            :grade => nil,
            :year => nil,
            :module => nil,
            :date => Time.now,
            :language => language
        }
        declarations_language_previous = DeclarationsSubject.find(:first, :conditions => ['declaration_id = ? AND user_id = ? AND subject_id = ?', @declaration_id, @logged_user.id, subject.to_i])
        if declarations_language_previous
          DeclarationsSubject.update(declarations_language_previous.id, declarations_language)
        else
          DeclarationsSubject.new(declarations_language).save
        end
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
    @declarations_subjects = DeclarationsSubject.find(:all, :include => :subject, :conditions => ['declaration_id = ? AND user_id IS NULL', Declaration.find_by_code('WJd2Rz').id])
    @template = 'deanery/declarations/' + params[:declaration][:code] if params[:declaration][:code]
  end
  
  def fill_selects subject, language
    @declarations_language[(IdEncoder.encode(subject) + '_a')] = language[0..1]
    @declarations_language[(IdEncoder.encode(subject) + '_b')] = language[2..3]
  end
end
