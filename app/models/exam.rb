class Exam < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject
  belongs_to :exams_name
  attr_human_name :date => 'Czas egzaminu'
  attr_human_name :examiner => 'Prowadzący'
  attr_human_name :place => 'Miejsce'
  attr_human_name :term => 'Termin egzaminu'
  validates_presence_of :date, :message => 'nie został poprawnie wypełniony'
  validates_presence_of :examiner, :place, :message => 'nie może być pustym polem'
  validates_presence_of :term, :message => 'nie został wybrany'
end
