class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
	if params[:email].blank?
		flash[:notice_login] = 'Email required'
		render "new"
	elsif params[:password].blank?
		flash[:notice_login] = 'Password required'
		render "new"
    elsif user
      session[:user_id] = user.id
      redirect_to todos_path, :notice => "Logged in!"
    else
      #flash.now.alert = "Invalid email or password"
	  flash[:notice_login] = 'Invalid email or password'
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end


  def reset_password
	unless params[:id].blank?
		@o_user = User.find(params[:id].to_i)
		if @o_user.token != params[:token].to_s
			render :text => 'token expired'
		end
	else
			render :text => 'token expired'	
	end
  end

  def reset_password_save
	@o_user = User.find(params[:id].to_i)
	@token_link = BASE_URL + '/reset_password?id=' + params[:id].to_s + '&token=' + params[:token].to_s
	if params[:user][:password].blank?
		flash[:error_msg] = "password required"
		redirect_to @token_link
	elsif params[:user][:password].to_s != params[:user][:password_confirmation].to_s
		flash[:error_msg] = "password does not match"
		redirect_to @token_link
	else
		if @o_user.update_attributes(params[:user])
		   @o_user.token = ''
		   @o_user.save
		  flash[:notice] = "password successfully updated"
		  redirect_to root_url
		else
		  flash[:error_msg] = "password does not updated"
		  redirect_to root_url
		end
	end
  end

  def change_password
	unless params[:user].blank?
		unless params[:user][:email].blank?
			@o_user_email = User.find_by_email(params[:user][:email])
			if @o_user_email
				@o_user = User.find(current_user.id)
				new_token = SecureRandom.hex(10)
				@o_user.token = new_token
				@o_user.save
				@token_link = BASE_URL + '/reset_password?id=' + current_user.id.to_s + '&token=' + new_token.to_s
			  body = render_to_string(:partial => "users/reset_password_mail", :locals => { :username => @o_user.email, :token_link => @token_link}, :formats => [:html])
			  body = body.html_safe
			  UserMailer.reset_password_confirmation(@o_user, body).deliver
				flash[:error_message] = 'Reset password request sent to ' + @o_user.email
			else
				@o_user = User.new
				flash[:error_message] = "Email address is not exist."
			end 
		else
			@o_user = User.new
			flash[:error_message] = "Email address required."
		end
	else
	   @o_user = User.new
	end
  end
end
