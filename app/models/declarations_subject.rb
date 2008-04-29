class DeclarationsSubject < ActiveRecord::Base
  belongs_to :declaration
  belongs_to :subject
end
