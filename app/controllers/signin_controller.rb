class SigninController < ApplicationController
  
  def index
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:user][:login], params[:user][:password])
      if user
        session[:user_id] = user.id
        if params[:remember_me]
          // ##TODO##
        end
        if request.env['HTTP_REFERER']
          redirect_to request.env['HTTP_REFERER']
        else
          redirect_to :controller => 'index'
        end
        return
      else
        flash[:notice] = 'Nieprawidłowa nazwa użytkownika lub hasło'
      end
    end
    redirect_to :controller => 'index'
  end

  def signout
    session[:user_id] = nil
    redirect_to :controller => 'index'
  end
  
  def remindme
    if @logged_user
      redirect_to :controller => 'index'
    end
    if request.post?
      @user = User.find(:first, :include => :users_student, :conditions => ['firstname = ? and lastname = ? and sindex = ?', params[:user][:firstname], params[:user][:lastname], params[:users_student][:sindex]])
      if @user
        @user.password = nil
        @user.login = nil
        unless @user.question.nil? or @user.question.empty? or @user.answer.nil? or @user.answer.empty?
          @user.answer = nil
          render :template => 'signin/ask_question'
        else
          render :template => 'signin/no_question'
        end
      else
        render :template => 'signin/no_user'
      end
    end
  end
  
  def answer
    if @logged_user
      redirect_to :controller => 'index'
    end
    if request.post?
      user = User.find(IdEncoder.decode(params[:user_id]))
      if user
        if user.answer == params[:user][:answer]
          session[:user_id] = user.id
          redirect_to :controller => 'index'
        else
          render :template => 'signin/wrong_answer'
        end
      else
        redirect_to :controller => 'index'
      end
    else
      redirect_to :controller => 'index'
    end
  end

end
