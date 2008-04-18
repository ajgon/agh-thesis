class ProfileController < ApplicationController
  def view
    login = params[:login_name]
      @profile = User.find(:first, :conditions => ['login = ?', login])
    if @logged_user or @profile.is_lecturer?
      @news = News.find(:all, :conditions => ['user_id = ?', @profile.id], :limit => 5, :order => 'date DESC')
      @files = UploadedFile.find(:all, :conditions => ['user_id = ? and uploaded_files.kind = ?', @profile.id, 'material'], :include => [:subject, :user], :limit => 5, :order => 'date DESC')
      @grades = UploadedFile.find(:all, :conditions => ['user_id = ? and uploaded_files.kind = ?', @profile.id, 'grade'], :include => [:subject, :user], :limit => 5, :order => 'date DESC')
      @subjects = UploadedFile.find(:all, :include => [:user, :subject], :conditions => ['users.id = ?', @profile.id], :group => 'subjects.id')
      render :template => 'profile/index'
    else
      render :template => 'signin/signin'
    end
  end
end
