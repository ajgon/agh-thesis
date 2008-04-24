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
  end  
  
  def news
    if request.post?
      news = {
        :head => params[:news][:head],
        :body => params[:news][:body],
        :date => Time.now,
        :user_id => @logged_user.id
      }
      news[:ip] = request.remote_ip.to_s unless request.remote_ip.to_s.empty?
      if params[:news][:type] == 'year'
        for_year =  (params[:news][:year_1].to_i * 1 | params[:news][:year_2].to_i * 2 | params[:news][:year_3].to_i * 4 | params[:news][:year_4].to_i * 8 | params[:news][:year_5].to_i * 16)
        for_year = (for_year < 1 or for_year > 31 ? 31 : for_year)
        news[:for_year] = for_year
        news[:subject_id] = nil
      else
        params[:news][:subject_id] = IdEncoder.decode(params[:news][:subject_id])
        if params[:news][:subject_id] and params[:news][:subject_id].to_i != 0
          news[:subject_id] = params[:news][:subject_id].to_i
          news[:for_year] = Subject.find(news[:subject_id]).year
        else
          news[:for_year] = 31
        end
      end
      edited_news_id = IdEncoder.decode(params[:news][:edited])
      unless edited_news_id
        News.new(news).save!
      else
        News.update(edited_news_id, news)
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
    @news = nil
    if params[:id] == 'edit'
      @edited_news = News.find(IdEncoder.decode(params[:page]))
      form_edited_news = {
        :head => @edited_news.head,
        :body => @edited_news.body,
        :year_1 => @edited_news.for_year & 1,
        :year_2 => (@edited_news.for_year & 2) / 2,
        :year_3 => (@edited_news.for_year & 4) / 4,
        :year_4 => (@edited_news.for_year & 8) / 8,
        :year_5 => (@edited_news.for_year & 16) / 16,
        :subject_id => IdEncoder.encode(@edited_news.subject_id)
      }
      form_edited_news[:type] = 'subject_id' if form_edited_news[:subject_id]
      @news = HashWithMethods.new(form_edited_news)
    end
    @subjects = [['---', '']] + Subject.find(:all, :order => 'head').collect {|i| [i.head, IdEncoder.encode(i.id)]}
    @logged_user_news = News.find(:all, :conditions => ['user_id = ?', @logged_user.id], :order => 'date DESC')
    @pager = Pager.new({:controller => params[:controller], :action => params[:action], :id => params[:id]}, @logged_user_news, :id, nil, 5)
  end
  
  def grades
  end
  
  def polls
  end
  
  def groups
  end
  
  def declarations
  end
  
  def calendar
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
