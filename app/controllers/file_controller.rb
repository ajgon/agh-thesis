class FileController < ApplicationController
  def download
    file_id = IdEncoder.decode(params[:id])
    if file_id and UploadedFile.exists?(file_id) and File.exists?(file = RAILS_ROOT + '/files/' + UploadedFile.find(file_id).filename)
      send_file file
    else
      render :template => 'file/not_found'
    end
  end
end
