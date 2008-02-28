class ProfileController < ApplicationController
  def method_missing login
    @profile = User.find(:first, :conditions => ['login = ?', login])
    @news = News.find(:all, :conditions => ['user_id = ?', @profile.id], :limit => 5, :order => 'date DESC')
    @files = UploadedFile.find(:all, :conditions => ['user_id = ?', @profile.id], :include => [:subject, :user], :limit => 5, :order => 'date DESC')
    render :template => 'profile/index'
  end
end
