class PollsQuestion < ActiveRecord::Base
  belongs_to :user
  has_many :polls_answers
end
