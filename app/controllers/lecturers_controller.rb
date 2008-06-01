class LecturersController < ApplicationController
  def index
    @lecturers = UsersLecturer.find(:all, :include => [:user, :cathedral], :order => 'users.lastname, users.firstname')
    @letters = letters_from @lecturers
    @title = 'Wszyscy'
  end
  
  def method_missing cathedral_name
    if cathedral = Cathedral.find_by_action(cathedral_name)
      @lecturers = UsersLecturer.find(:all, :conditions => ['cathedral_id = ?', cathedral.id], :include => [:user, :cathedral], :order => 'users.lastname, users.firstname')
      @letters = letters_from @lecturers
      @title = cathedral.name
      render :template => 'lecturers/index'
    else
      redirect_to :controller => 'lecturers', :action => 'index'
    end
  end
    
  private
  def letters_from lecturers
    letters = []
    lecturers.each do |lecturer|
      letters.push lecturer.user.lastname.first
    end
    letters.uniq
  end
end
