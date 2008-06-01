class RtfController < ApplicationController
  
  def experience
    if @logged_user and @logged_user.configures_declarations? and (speciality_id = IdEncoder.decode(params[:id]))
      @boss = "dr\\~in\\'bf.\\~Witolda Machowskiego"
      @declarations_experience = DeclarationsExperience.find(:all, :conditions => ['speciality_id = ?', speciality_id])
      content = render :file => 'app/views/rtf/experience.rtf'
      send_data content, :type => 'application/rtf', :filename => 'experience.rtf'
    else
      render :template => 'index/forbidden'
    end
  end
  
end
