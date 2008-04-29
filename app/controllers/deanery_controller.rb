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
        if UsersStudent.find_by_sindex(params[:users_student][:sindex]) and UsersStudent.find_by_sindex(params[:users_student][:sindex]).user_id == @logged_user.id
          case params[:declaration][:code]
          when 'WMd1R'
            @declarations_subjects = DeclarationsSubject.find(:all, :include => [:declaration, :subject], :conditions => ['declarations.code = ? AND user_id IS NULL', 'WMd1R'])
            already_filled = (DeclarationsSubject.count('*', :conditions => ['user_id = ? AND declaration_id = ?', @logged_user.id, Declaration.find_by_code('WMd1R')]) != 0)
            if params[:declarations_subject] and !params[:back] and !already_filled
              valid_subjects = Hash[*(DeclarationsSubject.find(:all, :include => [:declaration, :subject], :conditions => ['declarations.code = ? AND user_id IS NULL', 'WMd1R']).collect { |i| [i.subject_id, nil] }).flatten]
              given_subjects = Hash[*(params[:declarations_grade].sort.collect { |i| [IdEncoder.decode(i[0]), i[1]]}).flatten]
              @merged_subjects = Hash[*((valid_subjects.merge(given_subjects).delete_if {|key, value| !valid_subjects.include?(key)}).sort.collect {|i| [i[0], i[1].to_f]}).flatten]
              @average = (@merged_subjects.values.sum / @merged_subjects.values.length).to_s[0..3]
              params[:declarations_subject][:module] = 'E' unless ['E', 'T'].include?(params[:declarations_subject][:module])
              params[:declarations_subject][:year] = Time.now.year - @logged_user.users_student.year - (Time.now.month > 9 ? 1 : 0) unless (1970..Time.now.year).include?(params[:declarations_subject][:year].to_i)
              if params[:final_commit]
                @merged_subjects.each_pair do |subject, grade|
                  (declarations_subject = DeclarationsSubject.new({
                    :declaration_id => Declaration.find_by_code('WMd1R'),
                    :subject_id => subject.to_i,
                    :user_id => @logged_user.id,
                    :grade => grade,
                    :year => params[:declarations_subject][:year],
                    :module => params[:declarations_subject][:module],
                    :date => Time.now
                  })).save
                end
                render :template => 'deanery/declarations/WMd1R_done'
              else
                render :template => 'deanery/declarations/WMd1R_1'
              end
            else
              @declarations_subject = HashWithMethods.new(params[:declarations_subject]) if params[:declarations_subject]
              @declarations_grade = HashWithMethods.new(params[:declarations_grade]) if params[:declarations_grade]
              unless already_filled
                render :template => 'deanery/declarations/' + params[:declaration][:code] if params[:declaration][:code]
              else
                render :template => 'deanery/declarations/' + params[:declaration][:code] + '_done' if params[:declaration][:code]
              end
            end
          end
        end
      end
      @declarations = Declaration.find(:all, :conditions => ['year = ?', @logged_user.users_student.year]) if @logged_user.is_student?
    else
      render :template => 'signin/signin'
    end
  end
  
end
