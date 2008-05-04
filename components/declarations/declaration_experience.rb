class DeclarationExperience < Declarations
  attr_reader :declarations_experience, :declarations_experiences_dates, :beginning, :experiences, :confirmations
  
  def initialize(params, logged_user, settings = false)
    super
    unless settings
      execute params
    else
      setup params
    end
  end
  
  def execute params
    day = 20
    while(Time.mktime(Time.now.year,06,day).strftime('%a') != 'Mon')
      day += 1
    end
    @beginning = []
    month = 6
    days = {6 => 30, 7 => 31, 8 => 31}
    12.times do |iteration|
      begin
      time = Time.mktime(Time.now.year,month,(day + iteration * 7)).strftime('%Y-%m-%d')
      rescue
        day -= days[month]
        month += 1
      end
      time = Time.mktime(Time.now.year,month,(day + iteration * 7)).strftime('%Y-%m-%d')
      @beginning.push [time, time]
    end
    @template = 'experience'
    if params[:declarations_experience]
      params[:declarations_experience][:declaration_id] = @declaration_id
      params[:declarations_experience][:firstname] = @logged_user.firstname
      params[:declarations_experience][:lastname] = @logged_user.lastname
      params[:declarations_experience][:sindex] = params[:users_student][:sindex]
      params[:declarations_experience][:speciality_id] = @logged_user.users_student.speciality_id
      params[:declarations_experience][:beginning] = Time.mktime(params[:declarations_experiences_dates][:beginning][0..3].to_i, params[:declarations_experiences_dates][:beginning][5..6].to_i, params[:declarations_experiences_dates][:beginning][8..9].to_i)
      params[:declarations_experience][:beginning_additional] = Time.mktime(params[:declarations_experiences_dates][:beginning_additional_year].to_i, params[:declarations_experiences_dates][:beginning_additional_month].to_i, params[:declarations_experiences_dates][:beginning_additional_day].to_i)
      params[:declarations_experience][:ending_additional] = Time.mktime(params[:declarations_experiences_dates][:ending_additional_year].to_i, params[:declarations_experiences_dates][:ending_additional_month].to_i, params[:declarations_experiences_dates][:ending_additional_day].to_i)
      @declarations_experience = DeclarationsExperience.new(params[:declarations_experience])
      if(@declarations_experience.valid? and declaration_previous = DeclarationsExperience.find_by_sindex(params[:declarations_experience][:sindex]))
        @declarations_experience = DeclarationsExperience.update(declaration_previous.id, params[:declarations_experience])
        @flash_notice = 'Deklaracja została poprawiona'
      else
        @flash_notice = 'Deklaracja została dodana' if @declarations_experience.save
      end
    end
    if @declarations_experience.nil? and DeclarationsExperience.find(:first, :conditions => ['sindex = ? AND declaration_id = ?', params[:users_student][:sindex], @declaration_id])
      @declarations_experience = DeclarationsExperience.find(:first, :conditions => ['sindex = ? AND declaration_id = ?', params[:users_student][:sindex], @declaration_id])
      @declarations_experiences_dates = HashWithMethods.new({
          :beginning => @declarations_experience.beginning.strftime('%Y-%m-%d'),
          :beginning_additional_year => @declarations_experience.beginning_additional.year,
          :beginning_additional_month => @declarations_experience.beginning_additional.month,
          :beginning_additional_day => @declarations_experience.beginning_additional.day,
          :ending_additional_year => @declarations_experience.ending_additional.year,
          :ending_additional_month => @declarations_experience.ending_additional.month,
          :ending_additional_day => @declarations_experience.ending_additional.day,
      })
    end
  end
  
  def setup params
      if params[:page]
        @experiences = DeclarationsExperience.find(IdEncoder.decode(params[:page]), :include => :speciality)
        @confirmations = HashWithMethods.new({
          :one => @experiences.confirmations & 1,
          :two => (@experiences.confirmations & 2) / 2,
          :three => (@experiences.confirmations & 4) / 4,
          :four => (@experiences.confirmations & 8) / 8,
          :five => (@experiences.confirmations & 16) / 16,
        })
        @template = 'experience_1'
      else
        @experiences = DeclarationsExperience.find(:all, :conditions => ['declaration_id = ?', @declaration_id])
        @template = 'experience'
      end
  end
end
