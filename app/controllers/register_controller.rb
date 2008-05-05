class RegisterController < ApplicationController
  def index
    if @logged_user
      redirect_to :controller => 'index'
    end
    if request.post?
      if (user = User.find(:first, :include => :users_student, :conditions => ['firstname = ? AND lastname = ? AND sindex = ?', params[:user][:firstname], params[:user][:lastname], params[:users_student][:sindex].to_i])) and user.login.nil?
        params[:users_student][:sindex] = params[:users_student][:sindex].to_i
        @user = User.new(params[:user])
        if @user.valid?
          User.update(user.id, params[:user])
          session[:user_id] = user.id
          redirect_to :controller => 'index', :action => 'index'
        else
          @user.password = nil
          @user.login = nil
        end
      else
        render :template => 'index/forbidden'
      end
    else
    end
  end
end
