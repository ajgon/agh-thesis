class CsvController < ApplicationController

  before_filter :allowed_to_view, :set_separator
  
  def allowed_to_view
    if @logged_user
      unless @logged_user.configures_declarations?
      render :template => 'index/forbidden'
      else
        @declaration_id = IdEncoder.decode(params[:id][1..-1])
        @second_id = IdEncoder.decode(params[:page])
        render :template => 'file/not_found' unless @declaration_id and ((@second_id and !['experience', 'module'].include?(params[:action])) or ['experience', 'module'].include?(params[:action]))
      end
    else
      render :template => 'signin/signin'
    end
  end
  
  def set_separator
    @separator = params[:id] == 98 ? ';' : ','
  end

  def language
    csv_table = 
      [Subject.find(@second_id).head] + 
      ['Imię' + @separator + 'Nazwisko' + @separator + 'Wykład' + @separator + 'Dodatkowe'] + 
      DeclarationsSubject.find(:all, :include => :user, :conditions => ['declaration_id = ? and subject_id = ? AND user_id IS NOT NULL', @declaration_id, @second_id]).collect {|i| i.user.firstname + @separator + i.user.lastname + @separator + i.language[0..1] + @separator + i.language[2..3]}
    send_csv(csv_table)
  end
  
  def print
    csv_table = 
      [Subject.find(@second_id).head] +
      ['Imię' + @separator + 'Nazwisko' + @separator + 'Wydruk'] +
      DeclarationsSubject.find(:all, :include => :user, :conditions => ['declaration_id = ? AND subject_id = ? AND user_id IS NOT NULL', @declaration_id, @second_id]).collect {|i| i.user.firstname + @separator + i.user.lastname + @separator + (i.print ? 'tak' : 'nie')}
    send_csv(csv_table)
  end
  
  def module
    csv_table = 
      ['URL Deklaracji' + @separator + 'Imię' + @separator + 'Nazwisko' + @separator + 'Moduł' + @separator + 'Średnia Ocen'] +
      DeclarationsSubject.find(:all, :include => [:user, :speciality], :conditions => ['declaration_id = ? AND user_id IS NOT NULL', @declaration_id], :group => 'user_id').collect {|i| 'http://eit.agh.edu.pl/settings/declarations/' + Declaration.find(@declaration_id).code + '/' + IdEncoder.encode(i.id) + @separator + i.user.firstname + @separator + i.user.lastname + @separator + i.speciality.head + @separator + i.average.to_s[0..3]}
    send_csv(csv_table)
  end
  
  def subjects
    csv_table = 
      [Subject.find(@second_id).head] +
      ['Imię' + @separator + 'Nazwisko'] +
      DeclarationsSubject.find(:all, :include => :user, :conditions => ['declaration_id = ? AND subject_id = ? AND user_id IS NOT NULL', @declaration_id, @second_id]).collect {|i| i.user.firstname + @separator + i.user.lastname}
    send_csv(csv_table)
  end
  
  def experience
    csv_table = 
      ['Imię' + @separator + 'Nazwisko' + @separator + 'Numer albumu' + @separator + 'Termin'] +
      DeclarationsExperience.find(:all, :conditions => ['declaration_id = ? AND dormitory = true', @declaration_id], :order => 'beginning').collect {|i| i.firstname + @separator + i.lastname + @separator + i.sindex.to_s + @separator + i.beginning.to_s + ' - ' + (i.beginning + 4.weeks - (i.beginning_additional ? ((i.ending_additional ? i.ending_additional : Time.now) - i.beginning_additional) : 0)).to_s + (i.beginning_additional ? ' (' + i.beginning_additional.to_s + ' - ' + i.ending_additional.to_s + ')' : '') }
    send_csv(csv_table)
  end
  
  def speciality
    specialities = {
      1 => 'Sieci i Usługi Telekomunikacyjne',
      2 => 'Urządzenia i Systemy Teleinformatyczne',
      3 => 'Mikroelektronika i Aparatura Biomedyczna',
      4 => 'Aparatura Elektroniczna',
      5 => 'Sensory i Mikrosystemy'
    }
    csv_table = 
      ['Imię' + @separator + 'Nazwisko' + @separator + 'Numer albumu' + @separator + 'Tryb studiów' + @separator + 'Specjalność'] +
      DeclarationsSubject.find(:all, :include => :user, :conditions => ['declaration_id = ? AND speciality_id = ? AND user_id IS NOT NULL', @declaration_id, @second_id]).collect {|i| i.user.firstname + @separator + i.user.lastname + @separator + i.user.users_student.sindex.to_s + @separator + (i.study_type == 'M' ? 'Magisterskie' : 'Inzynierskie') + @separator + specialities[i.study_speciality.to_i].to_s}
    send_csv(csv_table)
  end
  
  private
  def send_csv csv_table
    csv = csv_table.join "\n"
    send_data csv, :type => 'application/excel', :filename => "#{params[:action]}.csv"
  end
  
end
