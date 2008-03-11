class FileController < ApplicationController
  def download
    file_id = IdEncoder.decode(params[:id])
    if file_id and UploadedFile.exists?(file_id) and File.exists?(file = RAILS_ROOT + '/files/' + UploadedFile.find(file_id).filename)
      if UploadedFile.is_public? file_id
        send_file file
      else
        # TODO rozpatrywanie uprawnien
        render :template => 'file/access_denied'
      end
    else
      render :template => 'file/not_found'
    end
  end
end
