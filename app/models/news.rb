class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :news_type
  has_many :groups_news
  
  def years
    number = (self.for_year > 30 or self.for_year < 0) ? 0 : self.for_year
    year_no = 0
    years = []
    while number != 0
      year_no += 1
      years.push year_no if number % 2 == 1
      number >>= 1
    end
    years = years.empty? ? '1-5' : years.join(', ')
    years
  end
end
