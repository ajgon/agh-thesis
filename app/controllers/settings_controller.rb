class SettingsController < ApplicationController
  
  before_filter :allowed_to_view
  
  def allowed_to_view
    if @logged_user
      render :template => 'index/forbidden' unless !@logged_user.respond_to?('configures_' + params[:action] + '?') or @logged_user.send('configures_' + params[:action] + '?')
    else
      render :template => 'signin/signin'
    end
  end
  
  def index
  end
  
  def materials
  end
  
  def news
  end
  
  def grades
  end
  
  def polls
  end
  
  def groups
  end
  
  def declarations
  end
  
  def calendar
  end
  
  def profile
    @users_lecturers_cathedral = Cathedral.find(:all).collect { |i| [ i.name, i.id ] }
    unless request.post?
      @user = User.find(session[:user_id], :include => [:users_student, :users_lecturer])
      if @user.users_student
        @users_student = UsersStudent.find(:first, :conditions => ['user_id = ?', session[:user_id]])
      else
        @users_lecturer = UsersLecturer.find(:first, :conditions => ['user_id = ?', session[:user_id]])
      end
      @user.password = nil
    else
      if params[:user][:pass].empty? or params[:user][:pass_confirmation].empty?
        params[:user][:pass] = '3aed121ab9caaf2e277f716312aa62e67d1d3ba0'
        params[:user][:pass_confirmation] = '3aed121ab9caaf2e277f716312aa62e67d1d3ba0'
      end
      @user = User.update(session[:user_id], params[:user])
      @user.pass = nil
      @user.pass_confirmation = nil
      if params[:users_student]
        users_student = UsersStudent.find(:first, :conditions => ['user_id = ?', session[:user_id]])
        @users_student = UsersStudent.update(users_student.id, params[:users_student])
      end
      if params[:users_lecturer]
        users_lecturer = UsersLecturer.find(:first, :conditions => ['user_id = ?', session[:user_id]])
        @users_lecturer = UsersLecturer.update(users_lecturer.id, params[:users_lecturer])
      end
    end
  end
end
