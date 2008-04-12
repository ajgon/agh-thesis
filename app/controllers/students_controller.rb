class StudentsController < ApplicationController
  
  def index
    
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
end
