class SubjectController < ApplicationController
  def method_missing acronym
    @subject = Subject.find(:first, :conditions => ['acronym = ?', acronym])
    @profiles = UploadedFile.find(:all, :include => [:user, :subject], :conditions => ['subjects.id = ?', @subject.id], :group => 'users.id')
    @files = UploadedFile.find(:all, :conditions => ['subject_id = ? and uploaded_files.kind = ?', @subject.id, 'material'], :include => [:subject, :user], :limit => 5, :order => 'date DESC')
    @grades = UploadedFile.find(:all, :conditions => ['subject_id = ? and uploaded_files.kind = ?', @subject.id, 'grade'], :include => [:subject, :user], :limit => 5, :order => 'date DESC')
    render :template => 'subject/index'
  end
end
