class FileController < ApplicationController
  def download
    file_id = IdEncoder.decode(params[:id])
    uploaded_file = UploadedFile.find(file_id)
    if file_id and UploadedFile.exists?(file_id) and File.exists?(file = RAILS_ROOT + '/files/' + uploaded_file.filename)
      if UploadedFile.is_public? file_id or (@logged_user and UploadedFile.can_user_get_file?(@logged_user.id, file_id))
        send_file file
        uploaded_file.downloads += 1
        uploaded_file.save
      else
        render :template => 'index/forbidden'
      end
    else
      render :template => 'file/not_found'
    end
  end
end
