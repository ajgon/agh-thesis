# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_charset
  layout 'index'

  def initialize
    @xhtml = false
    @controllers_map = {
      'about' => 'O Stronie',
      'deanery' => 'Dziekanat',
      'file' => 'Pliki',
      'index' => 'Aktualności',
      'lecturers' => 'Prowadzący',
      'materials' => 'Materiały',
      'news' => 'Aktualności',
      'postgraduate' => 'Podyplomowe',
      'profile' => 'Profile',
      'subject' => 'Przedmioty'
    }
  end

  def set_charset
    if /application\/xhtml\+xml(?![+a-z])(;q=(0\.\d{1,3}|[01]))?/i.match request.env["HTTP_ACCEPT"]
      xhtmlQ = !$2.nil? ? $2.to_f + 0.2 : 1
      if /text\/html(;q=(0\d{1,3}|[01]))s?/i.match(request.env["HTTP_ACCEPT"])
        htmlQ = !$2.nil? ? $2.to_f : 1
        @xhtml = xhtmlQ >= htmlQ
      else
        @xhtml = true
      end
    elsif !(/W3C_Validator/i.match(request.env["HTTP_USER_AGENT"]).nil?)
      @xhtml = true
    end

    if @xhtml
      headers["Content-Type"] = 'application/xhtml+xml; charset=utf-8'
    else
      headers["Content-Type"] = 'text/html; charset=utf-8'
    end

  end
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '1c0e64042b15000db3d4c42544713869'
end
