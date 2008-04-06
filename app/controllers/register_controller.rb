class RegisterController < ApplicationController
  def index
    if @logged_user
      redirect_to :controller => 'index'
    end
    if request.post?
      params[:users_student][:sindex] = params[:users_student][:sindex].to_i
      @user = User.new(params[:user])
      if @user.save
        @users_student = UsersStudent.new({:user_id => user.id, :sindex => params[:users_student][:sindex]})
        unless @users_student.save
          User.delete(user.id)
        end
      else
        @user.password = nil
        @user.login = nil
      end
    end
  end
end
