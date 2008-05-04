class DeclarationsSubject < ActiveRecord::Base
  belongs_to :declaration
  belongs_to :subject
  belongs_to :speciality
  belongs_to :user
end
