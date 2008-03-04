class IndexController < ApplicationController
  def index
    @news = News.find(:all, :include => :user, :order => 'news.id desc', :limit => 7)
    @files = UploadedFile.find(:all, :include => [:user, :subject], :order => 'uploaded_files.id desc', :limit => 7)
  end
end
