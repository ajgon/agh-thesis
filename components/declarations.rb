class Declarations
  attr_reader :declarations_subjects # Wszystkie przedmioty dotyczace tej deklaracji
  attr_reader :merged_subjects # Przedmioty i przypisany im parametr, po przejsciu przez parser sprawdzajacy poprawnos przeslanych danych
  attr_reader :flash_notice # Wiadomość do wyświetlenia
  attr_reader :template # Sciezka do template ktory ma byc wyrenderowany
  attr_reader :declaration_name
  
  def initialize(params, logged_user)
    @logged_user = logged_user
    @declaration_code = params[:declaration][:code]
    @declarations_subjects = DeclarationsSubject.find(:all, :include => [:declaration, :subject], :conditions => ['declarations.code = ? AND user_id IS NULL AND (speciality_id IS NULL or speciality_id = ?)', @declaration_code, @logged_user.users_student.speciality_id])
    @merged_subjects = nil
    @flash_notice = nil
    @template = nil
    declaration = Declaration.find_by_code(@declaration_code)
    @declaration_id = declaration.id
    @declaration_name = declaration.head
  end
  
  def merge_subjects subjects_hash
    valid_subjects = Hash[*(DeclarationsSubject.find(:all, :include => [:declaration, :subject], :conditions => ['declarations.code = ? AND user_id IS NULL', @declaration_code]).collect { |i| [i.subject_id, nil] }).flatten]
    given_subjects = Hash[*(subjects_hash.sort.collect { |i| [IdEncoder.decode(i[0]), i[1]]}).flatten]
    @merged_subjects = Hash[*((valid_subjects.merge(given_subjects).delete_if {|key, value| !valid_subjects.include?(key)}).sort.collect {|i| [i[0], (block_given? ? yield(i[1]) : i[1])]}).flatten]
  end
  
  def already_filled?
    (DeclarationsSubject.count('*', :conditions => ['user_id = ? AND declaration_id = ?', @logged_user.id, Declaration.find_by_code(@declaration_code)]) != 0)
  end
  
  def create_or_update subject, value
    declarations_previous = DeclarationsSubject.find(:first, :conditions => ['declaration_id = ? AND user_id = ? AND subject_id = ?', @declaration_id, @logged_user.id, subject.to_i])
    if declarations_previous
      DeclarationsSubject.update(declarations_previous.id, value)
    else
      DeclarationsSubject.new(value).save
    end
  end
end
