class RssController < ApplicationController
  def index
    @news = News.find(:all, :include => :user, :order => 'news.id DESC', :limit => 15)
    render :file => 'app/views/rss/index.html.erb'
  end
end
