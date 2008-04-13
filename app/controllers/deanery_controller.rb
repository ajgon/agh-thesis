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
  
  def eligible
    @subjects_electronics = Subject.find(:all, :select => 'subjects.id, subjects.code, subjects.head, subjects.season, COUNT(*) AS count', :joins => 'LEFT OUTER JOIN `subjects_types` ON `subjects_types`.id = `subjects`.subjects_type_id LEFT OUTER JOIN `declarations` ON declarations.subject_id = subjects.id', :conditions => "mandatory = false AND subjects_type_id <> 10 AND (code LIKE 'E%' OR code LIKE 'ET%')", :order => 'season, count DESC, code', :group => 'subject_id')
    @subjects_telecommunication = Subject.find(:all, :select => 'subjects.id, subjects.code, subjects.head, subjects.season, COUNT(*) AS count', :joins => 'LEFT OUTER JOIN `subjects_types` ON `subjects_types`.id = `subjects`.subjects_type_id LEFT OUTER JOIN `declarations` ON declarations.subject_id = subjects.id', :conditions => "mandatory = false AND subjects_type_id <> 10 AND (code LIKE 'T%' OR code LIKE 'ET%')", :order => 'season, count DESC, code', :group => 'subject_id')
    @subjects_choosen = []
    if @logged_user
      Declaration.find(:all, :conditions => ['user_id = ?', @logged_user.id]).each {|declaration| @subjects_choosen.push declaration.subject_id}
    end
  end
  
  def declarations
    if @logged_user
      if request.post?
        if UsersStudent.find_by_sindex(params[:users_student][:sindex])
          raise '##TODO## - deklaracje'
        end
      end
    else
      render :template => 'signin/signin'
    end
  end
  
end
