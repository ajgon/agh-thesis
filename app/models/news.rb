class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_type
  has_many :groups_news
end
