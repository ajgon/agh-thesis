class AboutController < ApplicationController
  def index
  end
  
  def eiteam
    @news_users = User.find(:all, :conditions => 'privileges >= 16', :include => :users_student, :order => 'users_students.sgroup')
  end
  
  def faq
    #TODO - przeredagowac pytania
  end
end
