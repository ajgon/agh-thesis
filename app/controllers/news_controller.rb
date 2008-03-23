class NewsController < ApplicationController
  
  def index
    @news = News.find(:all, :include => :user, :order => 'news.id desc')
    @pager = Pager.new({:controller => params[:controller], :action => params[:action], :id => params[:id]}, @news)
  end
  
  def exams
    @exams = Exam.find(:all, :order => 'exams_name_id, subject_id, date', :include => [:exams_name, :user, :subject])
  end
  
  def read
    news_id = IdEncoder.decode(params[:id])
    if news_id and News.exists?(news_id)
      @news = News.find(news_id)
      @last_news = News.find(:all, :include => :user, :order => 'news.id desc', :limit => 5)
    else
      render :template => 'news/not_found'
    end
  end
end
