class DeclarationSpeciality < Declarations
  attr_reader :type, :speciality, :declarations_speciality, :specialities
  
  def initialize(params, logged_user, settings = false)
    super
    unless settings
      execute params
    else
      setup params
    end
  end
  
  def execute params
    @type = [['Inżynierskie', 'I'], ['Magisterskie', 'M']]
    case @logged_user.users_student.speciality_id
    when 2
      @speciality = [
        ['Urządzenia i Systemy Teleinformatyczne', 2],
        ['Mikroelektronika i Aparatura Biomedyczna', 3],
        ['Aparatura Elektroniczna', 4],
        ['Sensory i Mikrosystemy', 5]
      ]
    when 3
      @speciality = [['Sieci i Usługi Telekomunikacyjne', 1]]
    else
      @speciality = []
    end
    if params[:declarations_speciality]
      params[:declarations_speciality][:study_type] = 'I' unless ['M', 'I'].include?(params[:declarations_speciality][:study_type])
      params[:declarations_speciality][:study_speciality] = 1 unless (1..@speciality.length).include?(params[:declarations_speciality][:study_speciality].to_i)
      @declarations_speciality = DeclarationsSubject.new({
        :declaration_id => @declaration_id,
        :user_id => @logged_user.id,
        :date => Time.now,
        :study_type => params[:declarations_speciality][:study_type],
        :study_speciality => params[:declarations_speciality][:study_speciality]
      })
      if(@declarations_speciality.valid? and declaration_previous = DeclarationsSubject.find(:first, :conditions => ['declaration_id = ? AND user_id = ?', @declaration_id, @logged_user.id]))
        @declarations_speciality = DeclarationsSubject.update(declaration_previous.id, @declarations_speciality.attributes)
        @flash_notice = 'Deklaracja została poprawiona'
      else
        @flash_notice = 'Deklaracja została dodana' if @declarations_speciality.save
      end
    end
    if @declarations_speciality.nil? and DeclarationsSubject.find(:first, :conditions => ['declaration_id = ? AND user_id = ?', @declaration_id, @logged_user.id])
      @declarations_speciality = DeclarationsSubject.find(:first, :conditions => ['declaration_id = ? AND user_id = ?', @declaration_id, @logged_user.id])
    end
    @template = 'speciality'
  end
  
  def setup params
    specialities = {
      1 => 'Sieci i Usługi Telekomunikacyjne',
      2 => 'Urządzenia i Systemy Teleinformatyczne',
      3 => 'Mikroelektronika i Aparatura Biomedyczna',
      4 => 'Aparatura Elektroniczna',
      5 => 'Sensory i Mikrosystemy'
    }
    types = {
      'I' => 'Inżynierskie',
      'M' => 'Magisterskie'
    }
    @specialities = [
      Hash[*((DeclarationsSubject.count(:all, :conditions => ['declaration_id = ? AND user_id IS NOT NULL', 10], :group => 'study_type').collect {|i| [types[i[0]], i[1]]}).flatten)],
      Hash[*((DeclarationsSubject.count(:all, :conditions => ['declaration_id = ? AND user_id IS NOT NULL', 10], :group => 'study_speciality').collect {|i| [specialities[i[0]], i[1]] }).flatten)]
    ]
    @template = 'speciality'
  end
end
