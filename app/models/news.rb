class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_type
  belongs_to :subject
  has_many :groups_news
end
