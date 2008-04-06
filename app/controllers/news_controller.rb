class NewsController < ApplicationController
  
  def index
    unless request.post?
      @news = News.find(:all, :include => :user, :order => 'news.id desc')
      @pager = Pager.new({:controller => params[:controller], :action => params[:action], :id => params[:id]}, @news)
    else
      c = params[:criteria]
      c.each_pair do |key, value|
        c[key] = value.gsub(',', ' ')
      end
      redirect_to :action => 'search', :id => "#{c['head']},#{c['body']},#{c['sort']},#{c['query']}"
    end
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
  
  def search
    @sort = [
      ['według trafności zapytania', 1],
      ['według daty dodania', 0]
    ]
    if params[:id]
      r = params[:id].split(',')
      params[:criteria] = {}
      params[:criteria][:head] = r[0]
      params[:criteria][:body] = r[1]
      params[:criteria][:sort] = r[2]
      params[:criteria][:query] = r[3]
      if params[:criteria][:sort].to_i == 1
        conditions = '1 = 0'
        if params[:criteria][:head].to_i == 1
          conditions += " OR (news.head LIKE '%" + params[:criteria][:query].split(' ').join("%' AND news.head LIKE '%") + "%')"
        end
        @news = News.find(:all, :conditions => conditions)
        conditions = '1 = 0'
        if params[:criteria][:body].to_i == 1
          conditions += " OR (news.body LIKE '%" + params[:criteria][:query].split(' ').join("%' AND news.body LIKE '%") + "%')"
        end
        @news += News.find(:all, :conditions => conditions)
        conditions = '1 = 0'
        if params[:criteria][:head].to_i == 1
          conditions += " OR news.head LIKE '%" + params[:criteria][:query].split(' ').join("%' OR news.head LIKE '%") + "%'"
        end
        @news += News.find(:all, :conditions => conditions)
        conditions = '1 = 0'
        if params[:criteria][:body].to_i == 1
          conditions += " OR news.body LIKE '%" + params[:criteria][:query].split(' ').join("%' OR news.body LIKE '%") + "%'"
        end
        @news += News.find(:all, :conditions => conditions)
      else
        conditions = '1 = 0'
        if params[:criteria][:head].to_i == 1
          conditions += " OR news.head LIKE '%" + params[:criteria][:query].split(' ').join("%' OR news.head LIKE '%") + "%'"
        end
        if params[:criteria][:body].to_i == 1
          conditions += " OR news.body LIKE '%" + params[:criteria][:query].split(' ').join("%' OR news.body LIKE '%") + "%'"
        end
        @news = News.find(:all, :conditions => conditions, :order => 'date DESC')
      end
      @pager = Pager.new({:controller => params[:controller], :action => params[:action], :id => params[:id], :page => params[:page]}, @news, :page)
      @criteria = HashWithMethods.new(params[:criteria])
    end
  end
end
