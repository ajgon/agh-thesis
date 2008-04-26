class StudentsController < ApplicationController
  
  def index
    if @logged_user
      @specialities = Speciality.find(:all).collect {|i| [i.head, IdEncoder.encode(i.id)]}
      @specialities[0][0] = '---'
      @sort = [
        ['Nazwisko', 'lastname'],
        ['Imię', 'firstname'],
        ['Login', 'login'],
        ['Rok', 'year'],
        ['Adres E-mail', 'email'],
        ['Nr telefony', 'cell'],
        ['Adres strony WWW', 'www_page'],
        ['Opis strony WWW', 'www_description'],
        ['Numer Gadu Gadu', 'gadu_gadu'],
        ['Numer ICQ', 'icq']
      ]
      @sort.push ['Numer indeksu', 'sindex'] if @logged_user.is_lecturer?
    else
      render :template => 'signin/signin'
    end
  end
  
  def results
    if @logged_user
      if request.post?
        criteria = params[:criteria].clone
        criteria.delete 'sort'
        criteria.delete 'year'
        criteria.delete 'speciality_id' if criteria[:speciality_id].nil? or IdEncoder.decode(criteria[:speciality_id]) == 1
        criteria.each_pair do |key, value|
          criteria.delete key if value.empty?
        end
        unless criteria.nil? or criteria.empty?
          criteria[:speciality_id] = IdEncoder.decode(criteria[:speciality_id]) if criteria[:speciality_id]
          conditions = [criteria.keys.join(' = ? AND ') + ' = ?'] + criteria.values
          unless params[:criteria][:year].nil? or params[:criteria][:year].empty?
            year = 'K%' + ((UsersStudent.find(:first, :order => 'sgroup DESC').sgroup[1..2].to_i + 1) - params[:criteria][:year].to_i).to_s + '_'
            conditions[0] += ' AND sgroup LIKE ?'
            conditions.push year
          end
          params[:criteria][:sort] = 'lastname' unless params[:criteria][:sort]
          params[:criteria][:sort] = 'sgroup DESC' if params[:criteria][:sort] == 'year'
          @results =  User.find(:all, :joins => :users_student, :conditions => conditions, :order => params[:criteria][:sort])
          @fields = (params[:results].delete_if {|key, value| value.to_i == 0}).keys
          @fields = ['login', 'firstname', 'lastname'] if @fields.empty?
          @fields = ['login', 'firstname', 'lastname', 'email', 'sgroup', 'gadu_gadu', 'cell', 'icq', 'www_page', 'www_description'] & @fields
          @fields_hash = {
            'login' => 'Login',
            'firstname' => 'Imię',
            'lastname' => 'Nazwisko',
            'email' => 'E-mail',
            'sgroup' => 'Kod Grupy',
            'gadu_gadu' => 'Gadu Gadu',
            'cell' => 'Nr Telefonu',
            'icq' => 'ICQ',
            'www_page' => 'Adres WWW',
            'www_description' => 'Opis WWW'
          }
        else
          redirect_to :controller => 'students', :action => 'index'
        end
      else
        redirect_to :controller => 'students', :action => 'index'
      end
    else
      render :template => 'signin/signin'
    end
  end
  
  def own_webpage  
  end
  
  def webpages
    @webpages = []
    dir = Dir.new(HOMEPAGES_DIRECTORY)
    dir.each do |dir|
      page = []
      if File.exists? HOMEPAGES_DIRECTORY + '/' + dir + '/public_html'
        page[0] = dir
        user = User.find_by_login(page[0])
        page[1] = user.firstname + '&nbsp;' + user.lastname unless user.nil?
        page[2] = File.read(HOMEPAGES_DIRECTORY + '/' + dir + '/public_html/.webinfo').gsub(/\n.*/, '') if File.exists? HOMEPAGES_DIRECTORY + '/' + dir + '/public_html/.webinfo'
      end
      @webpages.push page unless page.empty? or User.find_by_login(page[0]).nil?
    end
  end
  
  def polls
    if params[:id].nil? or (question_id = IdEncoder.decode(params[:id])) == false
      @polls_limit = 20
      @polls_closed = PollsQuestion.find(:all, :include => :user, :conditions => 'end_time IS NOT NULL AND end_time < NOW()', :order => 'polls_questions.id DESC', :limit => @polls_limit)
      @polls_open = PollsQuestion.find(:all, :include => :user, :conditions => 'end_time IS NULL OR end_time > NOW()', :order => 'polls_questions.id DESC', :limit => @polls_limit)
    else
      if params[:page].nil? or (answer_id = IdEncoder.decode(params[:page])) == false
        @poll = PollsQuestion.find(question_id, :include => [:polls_answers, :user], :order => 'polls_answers.quantity DESC')
        @polls_answers_amount = 0
        @poll.polls_answers.each do |polls_answer|
          @polls_answers_amount += polls_answer.quantity
        end
        @polls_answers_amount = 1 if @polls_answers_amount == 0
        render :template => 'students/poll'
      else
        polls_answer = PollsAnswer.find(answer_id)
        polls_answer.quantity += 1
        polls_answer.save
        unless PollsQuestion.find(question_id).anonymous
          @logged_user.voted = true 
          @logged_user.save
        end
        redirect_to :controller => 'index', :action => 'index'
      end
    end
  end
end
