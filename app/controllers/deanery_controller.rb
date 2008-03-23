class DeaneryController < ApplicationController
  def index
    @didactic = User.find(:first, :conditions => "firstname = 'Beata' and lastname = 'Idzik'")
    @social = User.find(:first, :conditions => "firstname = 'Małgorzata' and lastname = 'Matuła'")
    @experience = User.find(:first, :conditions => "firstname = 'Magdalena' and lastname = 'Skrzyniowska'")
  end
  
  def skeds
  end
  
  def experience
  end
  
  def subjects
    subjects_list = Subject.find(:all, :include => :subjects_type, :conditions => 'subjects.subjects_type_id < 8 and subjects_types.mandatory = true', :order => 'season, code')
    seasoned_hash = []
    subjects_list.each do |subject|
      if seasoned_hash[subject.season].nil?
        seasoned_hash[subject.season] = {}
      end
      module_code = ((subject.code[0].chr != 'E' and subject.code[0].chr != 'T') ? 'O' : subject.code[0].chr)
      if seasoned_hash[subject.season][module_code].nil?
        seasoned_hash[subject.season][module_code] = []
      end
      seasoned_hash[subject.season][module_code].push subject
    end
    @subjects = seasoned_hash
  end
  
  def english
  end
  
  def iep
  end
  
  def calendar
    @events = Event.find(:all, :order => 'ending')
  end
end
