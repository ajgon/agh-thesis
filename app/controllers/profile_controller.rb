class ProfileController < ApplicationController
  def method_missing login
    @profile = User.find(:first, :conditions => ['login = ?', login])
    render :template => 'profile/index'
  end
end
