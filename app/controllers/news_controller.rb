class NewsController < ApplicationController
  
  def index
    unless request.post?
      @news = News.find(:all, :include => [:user, :subject], :order => 'news.id desc')
      @pager = Pager.new({:controller => params[:controller], :action => params[:action], :id => params[:id]}, @news)
    else
      c = params[:criteria]
      c.each_pair do |key, value|
        c[key] = value.gsub(',', ' ')
      end
      redirect_to :action => 'search', :id => "#{c['head']},#{c['body']},#{c['sort']},#{c['query']}"
    end
  end
  
  def exams
    @exam = HashWithMethods.new({:term => '0'})
    if params[:id] == 'add' or params[:id] == 'edit' or params[:id] == 'delete'
      if @logged_user
        if @logged_user.respond_to?('configures_news?') and @logged_user.send('configures_news?')
          @edited_exam_id = nil
          if params[:id] == 'add' or (params[:id] == 'edit' and @edited_exam_id = IdEncoder.decode(params[:page]))
            @subjects = Subject.find(:all, :order => 'head').collect {|i| [i.head, IdEncoder.encode(i.id)]}
            @your_subjects = UploadedFile.find(:all, :include => [:subject, :user], :group => 'subject_id', :conditions => ['user_id = ?', @logged_user.id], :order => 'subjects.head').collect {|i| [i.subject.head, IdEncoder.encode(i.subject.id)] }
            @lecturers = [['', '']] + UsersLecturer.find(:all, :include => [:user, :cathedral], :order => 'users.lastname, users.firstname').collect {|i| [i.user.lastname + ' ' + i.user.firstname, i.user.lastname + ' ' + i.user.firstname]}
            @exams_names = ExamsName.find(:all, :order => 'id').collect {|i| [i.head, i.id]}
            if request.post?
              begin
                params[:exam][:date] = Time.mktime(params[:exams_date][:year].to_i, params[:exams_date][:month].to_i, params[:exams_date][:day].to_i, params[:exams_date][:hour].to_i, params[:exams_date][:minute].to_i)
              rescue
                params[:exam][:date] = nil
              end
              params[:exam][:subject_id] = IdEncoder.decode(params[:exam][:subject_id])
              params[:exam][:user_id] = @logged_user.id
              params[:exam][:examiner] = params[:examiner][:select] if params[:exam][:examiner].empty?
              unless params[:exam_params] and params[:exam_params][:edited] and edited_exam_id = IdEncoder.decode(params[:exam_params][:edited])
                if (@exam = Exam.new(params[:exam])).save
                  flash[:notice] = 'Egzamin został dopisany'
                  redirect_to :controller => 'news', :action => 'exams', :id => nil
                else
                  @exams_date = HashWithMethods.new(params[:exams_date])
                  render :template => 'news/add_exam'
                end
              else
                if (@exam = Exam.new(params[:exam])).valid?
                  Exam.update(edited_exam_id, params[:exam])
                  flash[:notice] = 'Dane dotyczące egzaminu zostały zmienione'
                  redirect_to :controller => 'news', :action => 'exams', :id => nil
                else
                  @exams_date = HashWithMethods.new(params[:exams_date])
                  render :template => 'news/add_exam'
                end
              end
            else
              if @edited_exam_id
                @exam = Exam.find(@edited_exam_id)
                @exams_date = HashWithMethods.new({
                    :year => @exam.date.year,
                    :month => @exam.date.month,
                    :day => @exam.date.day,
                    :hour => @exam.date.hour,
                    :minute => @exam.date.min
                })
              end
              render :template => 'news/add_exam'
            end
          else
            if deleted_exam_id = IdEncoder.decode(params[:page])
              Exam.delete(deleted_exam_id)
              flash[:notice] = 'Termin egzaminu został usunięty'
            end
          end
        else
          render :template => 'index/forbidden'
        end
      else
        render :template => 'signin/signin'
      end
    end
    @exams = Exam.find(:all, :order => 'exams_name_id, subject_id, date', :include => [:exams_name, :user, :subject]) unless params[:id] == 'add' or params[:id] == 'edit'
  end
  
  def read
    news_id = IdEncoder.decode(params[:id])
    if news_id and News.exists?(news_id)
      @news = News.find(news_id)
      @news.times_readed += 1
      @news.save
      @last_news = News.find(:all, :include => :user, :order => 'news.id desc', :limit => 5)
    else
      render :template => 'news/not_found'
    end
  end
  
  def search
    @sort = [
      ['według trafności zapytania', 1],
      ['według daty dodania', 0]
    ]
    if params[:id]
      r = params[:id].split(',')
      params[:criteria] = {}
      params[:criteria][:head] = r[0]
      params[:criteria][:body] = r[1]
      params[:criteria][:sort] = r[2]
      params[:criteria][:query] = r[3]
      if params[:criteria][:sort].to_i == 1
        conditions = '1 = 0'
        if params[:criteria][:head].to_i == 1
          conditions += " OR (news.head LIKE '%" + params[:criteria][:query].split(' ').join("%' AND news.head LIKE '%") + "%')"
        end
        @news = News.find(:all, :conditions => conditions)
        conditions = '1 = 0'
        if params[:criteria][:body].to_i == 1
          conditions += " OR (news.body LIKE '%" + params[:criteria][:query].split(' ').join("%' AND news.body LIKE '%") + "%')"
        end
        @news += News.find(:all, :conditions => conditions)
        conditions = '1 = 0'
        if params[:criteria][:head].to_i == 1
          conditions += " OR news.head LIKE '%" + params[:criteria][:query].split(' ').join("%' OR news.head LIKE '%") + "%'"
        end
        @news += News.find(:all, :conditions => conditions)
        conditions = '1 = 0'
        if params[:criteria][:body].to_i == 1
          conditions += " OR news.body LIKE '%" + params[:criteria][:query].split(' ').join("%' OR news.body LIKE '%") + "%'"
        end
        @news += News.find(:all, :conditions => conditions)
      else
        conditions = '1 = 0'
        if params[:criteria][:head].to_i == 1
          conditions += " OR news.head LIKE '%" + params[:criteria][:query].split(' ').join("%' OR news.head LIKE '%") + "%'"
        end
        if params[:criteria][:body].to_i == 1
          conditions += " OR news.body LIKE '%" + params[:criteria][:query].split(' ').join("%' OR news.body LIKE '%") + "%'"
        end
        @news = News.find(:all, :conditions => conditions, :order => 'date DESC')
      end
      raise 'x'
      @pager = Pager.new({:controller => params[:controller], :action => params[:action], :id => params[:id], :page => params[:page]}, @news, :page)
      @criteria = HashWithMethods.new(params[:criteria])
    end
  end
end
