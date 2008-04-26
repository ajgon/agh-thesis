class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_type
  belongs_to :subject
  has_many :groups_news
  attr_human_name :head => 'Tytuł'
  attr_human_name :body => 'Treść'
  validates_presence_of :head, :body, :message => 'nie może być pustym polem'
end
