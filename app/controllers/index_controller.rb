class IndexController < ApplicationController
  def index
    @news = News.find(:all, :include => :user, :order => 'news.id desc', :limit => 7)
  end
end
