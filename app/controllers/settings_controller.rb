class SettingsController < ApplicationController
  
  before_filter :allowed_to_view
  
  def allowed_to_view
    if @logged_user
      render :template => 'index/forbidden' unless !@logged_user.respond_to?('configures_' + params[:action] + '?') or @logged_user.send('configures_' + params[:action] + '?')
    else
      render :template => 'signin/signin'
    end
  end
  
  def index
  end

  def materials
    @edited_material = false
    if request.post? 
      if !params[:uploaded_file][:file].nil? and params[:uploaded_file][:file].respond_to?('original_filename')
        params[:uploaded_file][:filename] = params[:uploaded_file][:file].original_filename
        file_path = File.join(RAILS_ROOT, 'files', params[:uploaded_file][:filename])
        params[:uploaded_file][:filename] = rand(1679615).to_s(36) + '_' + params[:uploaded_file][:filename] if File.exists?(file_path)
        file_path = File.join(RAILS_ROOT, 'files', params[:uploaded_file][:filename])
        file = params[:uploaded_file][:file]
        params[:uploaded_file].delete :file
      end
      @uploaded_file = UploadedFile.new(params[:uploaded_file])
      @uploaded_file.user_id = IdEncoder.decode(params[:uploaded_file][:user_id])
      @uploaded_file.uploader_id = @logged_user.id
      @uploaded_file.subject_id = IdEncoder.decode(params[:uploaded_file][:subject_id])
      @uploaded_file.date = Time.now unless params[:groups_type][:edited]
      @uploaded_file.kind = (params[:action] == 'grades' ? 'grade' : 'material' )
      if(params[:groups_type][:edited].nil? and @uploaded_file.save)
        File.open(file_path, "wb") { |f| f.write(file.read) }
        groups_type = params[:groups_type][:gtype].to_i
        case groups_type
        when 1
          GroupsUploadedFile.new({:group_id => 1, :uploaded_file_id => @uploaded_file.id}).save!
        when 2
          GroupsUploadedFile.new({:group_id => IdEncoder.decode(params[:groups_uploaded_file_2][:group_id]), :uploaded_file_id => @uploaded_file.id}).save!
        when 3
          GroupsUploadedFile.new({:group_id => IdEncoder.decode(params[:groups_uploaded_file_3][:group_id]), :uploaded_file_id => @uploaded_file.id}).save!
        end
        @uploaded_file = nil
      end
      unless(params[:groups_type][:edited].nil?)
        groups_type = params[:groups_type][:gtype].to_i
        edited_file_id = IdEncoder.decode(params[:groups_type][:edited])
        groups_uploaded_files_id = GroupsUploadedFile.find(:first, :conditions => ['uploaded_file_id = ?', edited_file_id])
        groups_uploaded_files_id = (groups_uploaded_files_id.nil? ? nil : groups_uploaded_files_id.id)
        uploaded_file = UploadedFile.find(edited_file_id)
        @uploaded_file.filename = uploaded_file.filename
        @uploaded_file.kind = uploaded_file.kind
        @uploaded_file.date = uploaded_file.date
        case groups_type
        when 0
          GroupsUploadedFile.delete(groups_uploaded_files_id) unless groups_uploaded_files_id.nil?
        when 1
          if groups_uploaded_files_id.nil?
            GroupsUploadedFile.new({:group_id => 1, :uploaded_file_id => edited_file_id}).save!
          else
            GroupsUploadedFile.update(groups_uploaded_files_id, {:group_id => 1})
          end
        when 2
          if groups_uploaded_files_id.nil?
            GroupsUploadedFile.new({:group_id => IdEncoder.decode(params[:groups_uploaded_file_2][:group_id]), :uploaded_file_id => edited_file_id}).save!
          else
            GroupsUploadedFile.update(groups_uploaded_files_id, {:group_id => IdEncoder.decode(params[:groups_uploaded_file_2][:group_id])})
          end
        when 3
          if groups_uploaded_files_id.nil?
            GroupsUploadedFile.new({:group_id => IdEncoder.decode(params[:groups_uploaded_file_3][:group_id]), :uploaded_file_id => edited_file_id}).save!
          else
            GroupsUploadedFile.update(groups_uploaded_files_id, {:group_id => IdEncoder.decode(params[:groups_uploaded_file_3][:group_id])})
          end
        end
        UploadedFile.update(edited_file_id, @uploaded_file.attributes)
        redirect_to :controller => 'settings', :action => params[:action], :id => nil, :page => nil
      end
    end
    if params[:id] == 'delete' and IdEncoder.decode(params[:page])
      file = UploadedFile.find(IdEncoder.decode(params[:page]))
      if file.user_id == @logged_user.id or file.uploader_id == @logged_user.id
        file_path = File.join(RAILS_ROOT, 'files', file.filename)
        File.delete(file_path) if File.exists?(file_path)
        GroupsUploadedFile.delete( GroupsUploadedFile.find(:all, :conditions => ['uploaded_file_id = ?', file.id]).collect { |i| i.id } )
        UploadedFile.delete(file.id)
      end
      redirect_to :controller => 'settings', :action => params[:action], :id => nil, :page => nil
    end
    if params[:id] == 'edit' and IdEncoder.decode(params[:page])
      @uploaded_file_id = IdEncoder.decode(params[:page])
      @edited_material = true
      @uploaded_file = UploadedFile.find(@uploaded_file_id).attributes
      @uploaded_file['subject_id'] = IdEncoder.encode(@uploaded_file['subject_id'])
      @uploaded_file['user_id'] = IdEncoder.encode(@uploaded_file['user_id'])
      @uploaded_file = HashWithMethods.new(@uploaded_file)
      group_priv = GroupsUploadedFile.find(:first, :conditions => ['uploaded_file_id = ?', @uploaded_file_id])
      if group_priv.nil?
        @groups_type = HashWithMethods.new({:gtype => '0'})
      else
        @groups_type = HashWithMethods.new({:gtype => 1}) if group_priv.group_id == 1
        if group_priv.group_id > 19
          @groups_type = HashWithMethods.new({:gtype => '2'}) 
          @groups_uploaded_file_2 = HashWithMethods.new(:group_id => IdEncoder.encode(group_priv.group_id))
        end
        if (5..9).include? group_priv.group_id
          @groups_type = HashWithMethods.new({:gtype => '3'}) 
          @groups_uploaded_file_3 = HashWithMethods.new(:group_id => IdEncoder.encode(group_priv.group_id))
        end
      end
    end
    @your_subjects = UploadedFile.find(:all, :include => [:subject, :user], :group => 'subject_id', :conditions => ['user_id = ?', @logged_user.id], :order => 'subjects.head').collect {|i| [i.subject.head, IdEncoder.encode(i.subject.id)] }
    @subjects = Subject.find(:all, :order => 'head').collect {|i| [i.head, IdEncoder.encode(i.id)]}
    @lecturers = UsersLecturer.find(:all, :include => [:user, :cathedral], :order => 'users.lastname, users.firstname').collect {|i| [i.user.lastname + ' ' + i.user.firstname, IdEncoder.encode(i.user_id)]}
    @your_groups = Group.find(:all, :conditions => ['id > 19 AND user_id = ?', @logged_user.id], :order => 'head').collect {|i| [i.head, IdEncoder.encode(i.id)]}
    @other_groups = Group.find(:all, :conditions => 'id > 19 AND user_id IS NULL', :order => 'head').collect {|i| [i.head, IdEncoder.encode(i.id)]}
    if params[:action] == 'materials'
      @my_materials = UploadedFile.find(:all, :conditions => ['uploader_id = ? and kind = ?', @logged_user.id, 'material'], :order => 'id DESC')
    else
      @my_materials = UploadedFile.find(:all, :conditions => ['uploader_id = ? and kind = ?', @logged_user.id, 'grade'], :order => 'id DESC')
    end
    @other_materials = UploadedFile.find(:all, :conditions => ['user_id = ? and uploader_id <> ?', @logged_user.id, @logged_user.id], :order => 'id DESC')
  end  
  
  def news
    @news = nil
    @edited_news = false
    if request.post?
      news = {
        :head => params[:news][:head],
        :body => params[:news][:body],
        :date => Time.now,
        :user_id => @logged_user.id
      }
      news[:ip] = request.remote_ip.to_s unless request.remote_ip.to_s.empty?
      if params[:news_params][:ntype] == 'year'
        for_year =  (params[:news_params][:year_1].to_i * 1 | params[:news_params][:year_2].to_i * 2 | params[:news_params][:year_3].to_i * 4 | params[:news_params][:year_4].to_i * 8 | params[:news_params][:year_5].to_i * 16)
        for_year = (for_year < 1 or for_year > 31 ? 31 : for_year)
        news[:for_year] = for_year
        news[:subject_id] = nil
      else
        params[:news][:subject_id] = IdEncoder.decode(params[:news][:subject_id])
        if params[:news][:subject_id] and params[:news][:subject_id].to_i != 0
          news[:subject_id] = params[:news][:subject_id].to_i
          news[:for_year] = 1 << (Subject.find(news[:subject_id]).year - 1)
        else
          news[:for_year] = 31
        end
      end
      edited_news_id = IdEncoder.decode(params[:news_params][:edited])
      unless edited_news_id
        @news = News.new(news)
        @news.save
      else
        News.update(edited_news_id, news) if News.find(edited_news_id).user_id == @logged_user.id
      end
    end
    if params[:id] == 'delete'
      if IdEncoder.decode(params[:page])
        deleted_news = News.find(IdEncoder.decode(params[:page]))
        if @logged_user.id == deleted_news.user_id
          News.delete(deleted_news.id)
          redirect_to :controller => 'settings', :action => 'news', :id => '1', :page => nil
        else
          params.delete :id
          render :template => 'index/forbidden'
        end
      else
        redirect_to :controller => 'settings', :action => 'news', :id => '1', :page => nil
      end
    end
    if params[:id] == 'edit'
      dbnews = News.find(IdEncoder.decode(params[:page])).attributes
      news_params = {
        :year_1 => dbnews['for_year'] & 1,
        :year_2 => (dbnews['for_year'] & 2) / 2,
        :year_3 => (dbnews['for_year'] & 4) / 4,
        :year_4 => (dbnews['for_year'] & 8) / 8,
        :year_5 => (dbnews['for_year'] & 16) / 16,
      }
      news_params[:ntype] = 'year'
      news_params[:ntype] = 'subject_id' if dbnews['subject_id']
      dbnews['subject_id'] = IdEncoder.encode(dbnews['subject_id'])
      @news = HashWithMethods.new(dbnews)
      @news_params = HashWithMethods.new(news_params)
      @news_encoded_id = IdEncoder.encode(dbnews['id'])
      @edited_news = true
    end
    @subjects = [['---', '']] + Subject.find(:all, :order => 'head').collect {|i| [i.head, IdEncoder.encode(i.id)]}
    @logged_user_news = News.find(:all, :conditions => ['user_id = ?', @logged_user.id], :order => 'date DESC')
    @pager = Pager.new({:controller => params[:controller], :action => params[:action], :id => params[:id]}, @logged_user_news, :id, nil, 5)
  end
  
  def grades
    materials
  end
  
  def polls
    if request.post?
      params[:polls_question][:user_id] = @logged_user.id
      params[:polls_question][:start_time] = Time.now
      if params[:polls_closedate][:year].to_i >= Time.now.year and (1..12).include?(params[:polls_closedate][:month].to_i) and (1..31).include?(params[:polls_closedate][:day].to_i)
        params[:polls_question][:end_time] = Time.mktime(params[:polls_closedate][:year].to_i, params[:polls_closedate][:month].to_i, params[:polls_closedate][:day].to_i)
      end
      if (polls_question = PollsQuestion.new(params[:polls_question])).save
        polls_answers = params[:polls_answer].sort.collect { |i| i[1] unless i[1].empty? }
        polls_answers.compact.each do |polls_answer|
          PollsAnswer.new({:polls_question_id => polls_question.id, :answer => polls_answer}).save
          User.update_all('voted = 0')
        end
      end
      if polls_question.anonymous
        PollsQuestion.update_all('end_time = NOW()', '(end_time IS NULL OR end_time > NOW()) AND anonymous = true AND id <> ' + polls_question.id.to_s )
      else
        PollsQuestion.update_all('end_time = NOW()', '(end_time IS NULL OR end_time > NOW()) AND anonymous = false AND id <> ' + polls_question.id.to_s )
      end
    end
    if params[:id] == 'close' and (poll_id = IdEncoder.decode(params[:page]))
      poll = PollsQuestion.find(poll_id)
      poll.end_time = Time.now
      poll.save
      redirect_to :controller => 'settings', :action => 'polls', :id => nil, :page => nil
    end
    if params[:id] == 'delete' and (poll_id = IdEncoder.decode(params[:page]))
      PollsAnswer.delete( PollsAnswer.find(:all, :conditions => ['polls_question_id = ?', poll_id]).collect { |i| i.id } )
      PollsQuestion.delete(poll_id)
      redirect_to :controller => 'settings', :action => 'polls', :id => nil, :page => nil
    end
    @polls = PollsQuestion.find(:all, :include => :user, :order => 'polls_questions.id DESC')
  end
  
  def groups
    if (group_id = IdEncoder.decode(params[:id]))
      @group = Group.find(group_id)
      @group_members = User.find(:all, :include => [:groups_user, :users_student], :conditions => ['group_id = ?', group_id], :order => 'lastname')
      render :template => 'settings/group'
    else
      @groups = Group.find(:all, :conditions => ['user_id = ?', @logged_user.id], :order => 'head')
      @default_groups = Group.find(:all, :conditions => 'user_id IS NULL and id > 19', :order => 'head')
    end
    if request.post? and params[:id] != 'edit'
      params[:group][:user_id] = @logged_user.id
      unless edited_group_id = IdEncoder.decode(params[:group_params][:edited])
        Group.new(params[:group]).save
      else
        edited_group = Group.find(edited_group_id)
        params[:group][:user_id] = edited_group.user_id
        Group.update(edited_group_id, params[:group]) if edited_group.user_id == @logged_user.id
        redirect_to :controller => 'settings', :action => 'groups', :id => 'edit', :page => IdEncoder.encode(edited_group_id)
      end
    end
    if params[:id] == 'edit' and (group_id = IdEncoder.decode(params[:page]))
      @group = Group.find(group_id)
      @new_members = @search_members = HashWithMethods.new(Hash[*(GroupsUser.find(:all, :conditions => ['group_id = ?', group_id]).collect { |i| [IdEncoder.encode(i.user_id), '1'] }).flatten])
      if request.post? and params[:groups] and (group_with_members_id = IdEncoder.decode(params[:groups][:default]))
        @groups = HashWithMethods.new(params[:groups])
        @default_group_members = User.find(:all, :include => [:groups_user, :users_student], :conditions => ['group_id = ?', group_with_members_id], :order => 'lastname')
      end
      if request.post? and params[:groups_search]
        params[:groups_search].delete_if { |key, value| value.empty? }
        conditions = params[:groups_search].sort.collect {|i| "#{i[0]} LIKE '%#{i[1]}%'"}.join(' AND ') + ' AND users_students.user_id = users.id'
        @search_group_members = User.find(:all, :include => :users_student, :conditions => conditions, :order => 'lastname')
      end
      if request.post? and (params[:new_members] or params[:search_members])
        params_members = nil
        params_members = params[:new_members] if params[:new_members]
        params_members = params[:search_members] if params[:search_members]
        params_members.delete_if { |key, value| value.to_i == 0 }
        params_members.keys.each do |member_encoded_id|
          member_id = IdEncoder.decode(member_encoded_id)
          GroupsUser.new({:group_id => @group.id, :user_id => member_id}).save if @group.user_id == @logged_user.id and !GroupsUser.find(:first, :conditions => ['group_id = ? AND user_id = ?', @group.id, member_id])
        end
      end
      if request.post? and params[:old_members]
        params[:old_members].delete_if { |key, value| value.to_i == 0 }
        params[:old_members].keys.each do |member_encoded_id|
          member_id = IdEncoder.decode(member_encoded_id)
          GroupsUser.delete(GroupsUser.find(:first, :conditions => ['group_id = ? AND user_id = ?', @group.id, member_id]).id) if @group.user_id == @logged_user.id
        end
      end
      @group_members = User.find(:all, :include => [:groups_user, :users_student], :conditions => ['group_id = ?', @group.id], :order => 'lastname')
      render :template => 'settings/group_edit'
    end
    if params[:id] == 'delete' and (group_id = IdEncoder.decode(params[:page]))
      delete_group = Group.find(group_id)
      Group.delete(group_id) if delete_group.user_id == @logged_user.id
      redirect_to :controller => 'settings', :action => 'groups', :id => nil, :page => nil
    end
  end
  
  def declarations
  end
  
  def calendar
    @edited_calendar = false
    if request.post?
      if params[:event_enddate][:year].to_i >= Time.now.year and (1..12).include?(params[:event_enddate][:month].to_i) and (1..31).include?(params[:event_enddate][:day].to_i)
        params[:event][:ending] = Time.mktime(params[:event_enddate][:year].to_i, params[:event_enddate][:month].to_i, params[:event_enddate][:day].to_i)
      else
        params[:event][:ending] = Time.now
      end
      if (1..12).include?(params[:event_startdate][:month].to_i) and (1..31).include?(params[:event_startdate][:day].to_i)
        params[:event][:beginning] = Time.mktime(params[:event_startdate][:year].to_i, params[:event_startdate][:month].to_i, params[:event_startdate][:day].to_i)
      end
      params[:event][:for_year] = (params[:event_year][:year_1].to_i) + (params[:event_year][:year_2].to_i << 1) + (params[:event_year][:year_3].to_i << 2) + (params[:event_year][:year_4].to_i << 3) + (params[:event_year][:year_5].to_i << 4)
      unless(params[:event_params] and (edited_event_id = IdEncoder.decode(params[:event_params][:edited])))
        Event.new(params[:event]).save
      else
        Event.update(edited_event_id, params[:event])
      end
    end
    if params[:id] == 'delete' and (event_id = IdEncoder.decode(params[:page]))
      Event.delete(event_id)
    end
    if params[:id] == 'edit' and (event_id = IdEncoder.decode(params[:page]))
      @edited_calendar = true
      @event = Event.find(event_id)
      @event_encoded_id = IdEncoder.encode(event_id)
      @event_startdate = HashWithMethods.new({:year => @event.beginning.year, :month => @event.beginning.month, :day => @event.beginning.day})
      @event_enddate = HashWithMethods.new({:year => @event.ending.year, :month => @event.ending.month, :day => @event.ending.day})
      @event_year = HashWithMethods.new({
        :year_1 => @event['for_year'] & 1,
        :year_2 => (@event['for_year'] & 2) / 2,
        :year_3 => (@event['for_year'] & 4) / 4,
        :year_4 => (@event['for_year'] & 8) / 8,
        :year_5 => (@event['for_year'] & 16) / 16,
      })
    end
    @events = Event.find(:all, :order => 'ending')
  end
  
  def profile
    @users_lecturers_cathedral = Cathedral.find(:all).collect { |i| [ i.name, i.id ] }
    unless request.post?
      @user = User.find(session[:user_id], :include => [:users_student, :users_lecturer])
      if @user.users_student
        @users_student = UsersStudent.find(:first, :conditions => ['user_id = ?', session[:user_id]])
      else
        @users_lecturer = UsersLecturer.find(:first, :conditions => ['user_id = ?', session[:user_id]])
      end
      @user.password = nil
    else
      if params[:user][:pass].empty? or params[:user][:pass_confirmation].empty?
        params[:user][:pass] = '3aed121ab9caaf2e277f716312aa62e67d1d3ba0'
        params[:user][:pass_confirmation] = '3aed121ab9caaf2e277f716312aa62e67d1d3ba0'
      end
      @user = User.update(session[:user_id], params[:user])
      @user.pass = nil
      @user.pass_confirmation = nil
      if params[:users_student]
        users_student = UsersStudent.find(:first, :conditions => ['user_id = ?', session[:user_id]])
        @users_student = UsersStudent.update(users_student.id, params[:users_student])
      end
      if params[:users_lecturer]
        users_lecturer = UsersLecturer.find(:first, :conditions => ['user_id = ?', session[:user_id]])
        @users_lecturer = UsersLecturer.update(users_lecturer.id, params[:users_lecturer])
      end
    end
  end
end
