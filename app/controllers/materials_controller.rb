class MaterialsController < ApplicationController

  before_filter :fill_materials_search
  
  def fill_materials_search
    @files_top = UploadedFile.find(:all, :include => [:subject, :user], :limit => 10, :order => 'downloads DESC')
    @form_subjects = [['---', '']] + UploadedFile.find(:all, :include => :subject, :group => 'subject_id', :order => 'subjects.head').collect { |i| [ i.subject.head, IdEncoder.encode(i.subject.id) ] }
    if @logged_user and @logged_user.id and @logged_user.is_lecturer?
      @form_your_subjects = [['---', '']] + UploadedFile.find(:all, :include => [:subject, :user], :group => 'subject_id', :conditions => ['user_id = ?', @logged_user.id], :order => 'subjects.head').collect {|i| [i.subject.head, IdEncoder.encode(i.subject.id)] }
    else
      @form_your_subjects = nil
    end
    @form_profiles = [['---', '']] + UploadedFile.find(:all, :include => :user, :group => 'user_id', :order => 'users.lastname').collect { |i| [ i.user.lastname + ' ' + i.user.firstname, IdEncoder.encode(i.user.id) ] }
    @form_semesters = [
      ['---', ''],
      ['I. Rok', '101'],
      ['   1. Semestr', '1'],
      ['   2. Semestr', '2'],
      ['II. Rok', '102'],
      ['   3. Semestr', '3'],
      ['   4. Semestr', '4'],
      ['III. Rok', '103'],
      ['   5. Semestr', '5'],
      ['   6. Semestr', '6'],
      ['IV. Rok', '104'],
      ['   7. Semestr', '7'],
      ['   8. Semestr', '8'],
      ['V. Rok', '105'],
      ['   9. Semestr', '9'],
      ['   10. Semestr', '10'],
    ]
  end
  
  def index
    if params[:criteria].nil?
      @files = UploadedFile.find(:all, :include => [:user, :subject], :order => 'uploaded_files.id desc', :limit => 10)
    else
      c = params[:criteria]
      c.each_pair do |key, value|
        c[key] = value.gsub(',', ' ')
      end
      redirect_to :action => 'search', :id => "#{c['subject_id']},#{c['profile']},#{c['semester']},#{c['query']},#{c['sort']}"
    end
  end
  
  def search
    r = params[:id].nil? ? [] : params[:id].split(',')
    rules = {
      'subject_id' => IdEncoder.decode(r[0]), 
      'profile' => IdEncoder.decode(r[1]), 
      'semester' => ([1, 2, 3, 4, 5, 6, 7, 8 ,9, 10, 101, 102, 103, 104, 105].include?(r[2].to_i) ? r[2].to_i : nil), 
      'query' => r[3], 
      'sort' => (['date', 'downloads', 'head'].include?(r[4]) ? r[4] : 'date')
    }
    semester = rules['semester']
    semester = ((rules['semester'] - 100) * 2).to_s + ', ' + (((rules['semester'] - 100) * 2) - 1).to_s if (rules['semester'] - 100) > 0 if rules['semester']
    conditions = '1 = 1'
    conditions += ' AND subject_id = ' + rules['subject_id'].to_s if rules['subject_id']
    conditions += ' AND user_id = ' + rules['profile'].to_s if rules['profile']
    conditions += ' AND subjects.season IN(' + semester.to_s + ')' if semester
    if rules['query']
    conditions += ' AND (1 = 0'
      ['head', 'body', 'filename'].each do |column|
        conditions += " OR (uploaded_files.#{column} LIKE '%" + rules['query'].split(' ').join("%' OR uploaded_files.#{column} LIKE '%") + "%')"
      end
    conditions += ')'
    end
    
    @files = UploadedFile.find(:all, :include => [:subject, :user], :conditions => conditions, :order => (rules['sort'] + (rules['sort'] == 'head' ? '' : ' DESC')))
    @profiles = UploadedFile.find(:all, :include => [:user, :subject], :conditions => ['subjects.id = ?', rules['subject_id']], :group => 'users.id')
    @subjects = UploadedFile.find(:all, :include => [:user, :subject], :conditions => ['users.id = ?', rules['profile']], :group => 'subjects.id')
    params[:criteria] = rules
    params[:criteria][:subject_id] = IdEncoder.encode(params[:criteria][:subject_id]) if params[:criteria][:subject_id]
    params[:criteria][:profile] = IdEncoder.encode(params[:criteria][:profile]) if params[:criteria][:profile]
    params[:criteria][:semester] = params[:criteria][:semester].to_s
    pager_params = {:controller => params[:controller], :action => params[:action], :id => params[:id], :page => params[:page]}
    @pager = Pager.new(pager_params, @files, :page)
    @criteria = HashWithMethods.new(params[:criteria])
  end
  
  def grades
    if @logged_user
      @grades = UploadedFile.find_materials_for_user(session[:user_id], 'grade', false)
    else
      render :template => 'signin/signin'
    end
  end
end
