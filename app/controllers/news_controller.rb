class NewsController < ApplicationController
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
