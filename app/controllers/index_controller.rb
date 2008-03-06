class IndexController < ApplicationController
  def index
    @news = News.find(:all, :include => :user, :order => 'news.id desc', :limit => 7)
    @files = UploadedFile.find(:all, :include => [:user, :subject], :order => 'uploaded_files.id desc', :limit => 7)
    @poll = PollsQuestion.find(:first, :include => :polls_answers, :order => 'polls_questions.id DESC')
    @polls_answers_amount = 0
    @poll.polls_answers.each do |polls_answer|
      @polls_answers_amount += polls_answer.quantity
    end
    @grades = UploadedFile.find(:all, :conditions => ['uploaded_files.kind = ?', 'grade'], :include => :subject, :limit => 10, :order => 'date DESC')
  end
end
