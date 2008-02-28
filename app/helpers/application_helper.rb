# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def en_to_pl string
    case string
    when 'January'
      return 'Styczeń'
    when 'February'
      return 'Luty'
    when 'March'
      return 'Marzec'
    when 'April'
      return 'Kwiecień'
    when 'May'
      return 'Maj'
    when 'June'
      return 'Czerwiec'
    when 'July'
      return 'Lipiec'
    when 'August'
      return 'Sierpień'
    when 'September'
      return 'Wrzesień'
    when 'October'
      return 'Październik'
    when 'November'
      return 'Listopad'
    when 'December'
      return 'Grudzień'
    when 'Monday'
      return 'Poniedziałek'
    when 'Tuesday'
      return 'Wtorek'
    when 'Wednesday'
      return 'Środa'
    when 'Thursday'
      return 'Czwartek'
    when 'Friday'
      return 'Piątek'
    when 'Saturday'
      return 'Sobota'
    when 'Sunday'
      return 'Niedziela'
    else
      return string
    end
  end
  
  def roman_month string
    case string
    when '01'
      return 'I'
    when '02'
      return 'II'
    when '03'
      return 'III'
    when '04'
      return 'IV'
    when '05'
      return 'V'
    when '06'
      return 'VI'
    when '07'
      return 'VII'
    when '08'
      return 'VIII'
    when '09'
      return 'IX'
    when '10'
      return 'X'
    when '11'
      return 'XI'
    when '12'
      return 'XII'
    else
      return string
    end
  end
  
  def short_date date
    date.to_s(:short_time).
      gsub(/([A-Za-z]+)/) { en_to_pl($1) }.
      gsub(/([0-1][0-9]),/) { roman_month($1) + ','}.
      gsub(/ 0([0-9]) /) { " #{$1} "}
  end
  
  def dt_dd title, definition
    "<dt>#{title}</dt><dd>#{definition}</dd>"
  end
  
  def encode_string email, where
    output = ''
    for i in 0..email.length
      output << sprintf("&#x%x;", email[i])
    end
    output
    where.gsub(email, output).gsub(/x([0-9]);/) { "x0#{$1};" }
  end
  
  def content_type content = nil
    (content == 'left' ? ' content-left' : (content == 'right' ? ' content-right' : ''))
  end
end
