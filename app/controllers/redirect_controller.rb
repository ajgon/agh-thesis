class RedirectController < ApplicationController
  def index
    head :moved_permanently, :location => params[:new_url]
  end
end
