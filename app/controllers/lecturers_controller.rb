class LecturersController < ApplicationController
  def index
    @lecturers = UsersLecturer.find(:all, :include => [:user, :cathedral], :order => 'users.lastname, users.firstname')
    @letters = letters_from @lecturers
    @title = 'Wszyscy'
  end
  
  def electronics
    @lecturers = UsersLecturer.find(:all, :conditions => 'cathedral_id = 3', :include => [:user, :cathedral], :order => 'users.lastname, users.firstname')
    @letters = letters_from @lecturers
    @title = 'Elektronika'
    render :template => 'lecturers/index'
  end
  
  def telecommunication
    @lecturers = UsersLecturer.find(:all, :conditions => 'cathedral_id = 2', :include => [:user, :cathedral], :order => 'users.lastname, users.firstname')
    @letters = letters_from @lecturers
    @title = 'Telekomunikacja'
    render :template => 'lecturers/index'
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
