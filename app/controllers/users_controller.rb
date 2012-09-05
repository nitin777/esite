class UsersController < ApplicationController
  def new
    @user = User.new
	if @current_user
		redirect_to todos_path
	end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
	  body = render_to_string(:partial => "fronts/registration_mail", :locals => { :username => @user.email}, :formats => [:html])
	  body = body.html_safe
	  UserMailer.registration_confirmation(@user, body).deliver
      redirect_to root_url, :notice => "Signed up!"
    else
      render "new"
    end
  end
end
