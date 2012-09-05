class FrontsController < ApplicationController
  layout "fronts"

  def index
    @user_session = UserSession.new
  end

  def frontlogin
    @user_session = UserSession.new
  end

  def plan_price
    @o_all = Plan.all
  end

  def register
    @userdetail = Userdetail.new
  end

  def register_create
    @userdetail = Userdetail.new(params[:userdetail])
    
    if @userdetail.save
      flash[:success_msg] = t("general.please_registered_now")
	  redirect_to new_front_path
    else
      render :action => 'register'
    end
  end

  def signin
	@user_session = UserSession.new(params[:user_session])
	if params[:user_session][:username].blank?
		flash[:error_login] = t("general.username_required")
		redirect_to frontlogin_path
	elsif params[:user_session][:password].blank?
		flash[:error_login] = t("general.password_requied")
		redirect_to frontlogin_path
	elsif @user_session.save
		if current_user.is_active == true
			session[:user_id] = current_user.id
		    	session[:user_provider_id] = nil
			session[:user_provider] = nil
			flash[:success_msg] = t("general.login_successfully")
			@o_single = Page.where(:user_id => current_user.id).first
			if @o_single
				redirect_to contents_path
			else
				redirect_to fronts_path
			end
		else
  		    flash[:error_login] = t("general.inactive_user")
		    redirect_to frontlogin_path		
		end
    else
  		flash[:error_login] = t("general.credentials_not_valid")
	    redirect_to frontlogin_path
    end
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
	  @user.email = params[:user][:username]
	  @user.save
	  #body = render_to_string(:partial => "fronts/registration_mail", :locals => { :username => @user.username}, :formats => [:html])
	  #body = body.html_safe
	  #UserMailer.registration_confirmation(@user, body).deliver
	  @userdetail = Userdetail.last
	  @userdetail.user_id = @user.id
	  @userdetail.save

	  #params[:user_session][:username] = params[:user][:username]
	  #params[:user_session][:password] = params[:user][:password]
	  #@user_session = UserSession.new(params[:user_session])
  	  #@user_session.save
  	  session[:user_id] = @user.id



@content_value = "<b>" + @userdetail.desc + "</b><br /><b>Address:</b>" + @userdetail.address + "<br /><b>Open Hours:</b>" + @userdetail.office_hour + "<br /><b>Call Us Now:</b> <a href='tel:" + @userdetail.phone + "'>" + @userdetail.phone + "</a>	or <br /><a href='mailto:" + @userdetail.email + "'><b>send us email at: </b>" + @userdetail.email + "</a>"


	  @o_single = Page.new
	  @o_single.user_id = @user.id
	  @o_single.title = @userdetail.url + " " + @userdetail.desc
	  @o_single.content = @content_value
	  @o_single.url = @userdetail.url
	  @o_single.link_text = t("general.full_desktop_site")
	  @o_single.save

#write javascript file start

	secure_code = SecureRandom.hex(15)


	source = File.read(Rails.public_path + "/javascripts/mobile/redirection_mobile.js")
	directory_file = Rails.public_path + "/uploads/jsfiles/" + secure_code+".js"
	#target = File.open( directory_file , "w")
	#target.write( source )
target = File.open(directory_file, 'w') {|f| f.write(@source) }

	@base_mobile_url = "'" + BASE_URL_DOMAIN + "/show_page/" + @o_single.id.to_s + "?burl='+base_url"
	doc = "SA.redirection_mobile ({ noredirection_param: 'noredirection', mobile_url : "+@base_mobile_url+", mobile_prefix : 'https', cookie_hours : '2' });"

	File.open(directory_file, 'a') {|f| f.write(doc) }

	secure_file_name = 'u/'+@user.id.to_s+'/'+secure_code+'.js'
	bucket_name = 'pagender'
	source_filename = directory_file
	s3 = AWS::S3.new.buckets['pagender'].objects[secure_file_name]
	s3.write(:file => source_filename, :acl => :public_read)

	File.delete(directory_file)

	  @o_single.amazon_path = secure_file_name
	  @o_single.save

#write javascript file end


      flash[:success_msg] = t("general.successfully_registered_created_page")
	  redirect_to edit_content_register_path(@o_single.id, 'true')
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(current_user.id)
    @details = Userdetail.where(:user_id => current_user.id).last
	if @details
	    @userdetail = Userdetail.find(@details.id)
	else
	    @userdetail = Userdetail.new		
	end
  end
  
  def update
    @user = User.find(params[:user][:id])
    if @user.update_attributes(params[:user])
    	  @user.email = params[:user][:username]
	  @user.save
      flash[:success_msg] = t("general.profile_updated_successfully")
   	  redirect_to fronts_path
    else
		@details = Userdetail.where(:user_id => current_user.id).last
		if @details
			@userdetail = Userdetail.find(@details.id)
		else
			@userdetail = Userdetail.new		
		end
      render :action => 'edit'
    end
  end


  def update_macros_profile
	if !params[:userdetail][:id].blank?
		@userdetail = Userdetail.find(params[:userdetail][:id])
		if @userdetail.update_attributes(params[:userdetail])
			  flash[:success_msg] = t("general.profile_updated_successfully")
		   	  redirect_to fronts_path
		else
		  @user = User.find(current_user.id)
		  render :action => 'edit'
		end
	else
    	@userdetail = Userdetail.new(params[:userdetail])
	    if @userdetail.save
			flash[:success_msg] = t("general.profile_updated_successfully")
		   	  redirect_to fronts_path
		else
		  @user = User.find(current_user.id)
		  render :action => 'edit'
		end
	end
  end




  def update_macros

@content_value = "<b>" + params[:userdetail][:desc] + "</b><br /><b>Address:</b>" + params[:userdetail][:address] + "<br /><b>Open Hours:</b>" + params[:userdetail][:office_hour] + "<br /><b>Call Us Now:</b> <a href='tel:" + params[:userdetail][:phone] + "'>" + params[:userdetail][:phone] + "</a>	or <br /><a href='mailto:" + params[:userdetail][:email] + "'><b>send us email at: </b>" + params[:userdetail][:email] + "</a>"
			  @o_single = Page.new
			  @o_single.user_id = current_user.id
			  @o_single.title = params[:userdetail][:url] + " " + params[:userdetail][:desc]
			  @o_single.content = @content_value
			  @o_single.url = params[:userdetail][:url]
			  @o_single.link_text = t("general.full_desktop_site")
			  @o_single.save


			#write javascript file start
				secure_code = SecureRandom.hex(15)
				@source = File.read(Rails.public_path + "/javascripts/mobile/redirection_mobile.js")
				directory_file = Rails.public_path + "/uploads/jsfiles/" + secure_code+".js"
				#target = File.open( directory_file , "w")
				#target.write( source )
				target = File.open(directory_file, 'w') {|f| f.write(@source) }
				

	@base_mobile_url = "'" + BASE_URL_DOMAIN + "/show_page/" + @o_single.id.to_s + "?burl='+base_url"
	doc = "SA.redirection_mobile ({ noredirection_param: 'noredirection', mobile_url : "+@base_mobile_url+", mobile_prefix : 'https', cookie_hours : '2' });"

				File.open(directory_file, 'a') {|f| f.write(doc) }
				

				secure_file_name = 'u/'+current_user.id.to_s+'/'+secure_code+'.js'
				bucket_name = 'pagender'
				source_filename = directory_file
				s3 = AWS::S3.new.buckets['pagender'].objects[secure_file_name]
				s3.write(:file => source_filename, :acl => :public_read)

				#File.delete(directory_file)

				@o_single.amazon_path = secure_file_name
				@o_single.save
			#write javascript file end


		   	  redirect_to edit_content_path(@o_single)
  end

  def mobile_edit
	@o_userProvider = UserProvider.find(params[:id])

	@details = Userdetail.where('provider = ? AND user_id = ?', session[:user_provider], session[:user_provider_id].id).first
	
	if @details
	    @userdetail = Userdetail.find(@details.id)
	else
	    @userdetail = Userdetail.new		
	end

 end

  def mobile_edit_update
	@o_userProvider = UserProvider.find(params[:user_provider][:id])
    if @o_userProvider.update_attributes(params[:user_provider])
      flash[:success_msg] = t("general.profile_updated_successfully")
    end
	redirect_to fronts_path
  end



  def mobile_update_macros_profile
	if !params[:userdetail][:id].blank?
		@userdetail = Userdetail.find(params[:userdetail][:id])
		if @userdetail.update_attributes(params[:userdetail])
				flash[:success_msg] = t("general.profile_updated_successfully")
		   	  redirect_to fronts_path
		else
		  @o_userProvider = UserProvider.find(session[:user_provider_id].id)
		  render :action => 'mobile_edit'
		end
	else
    	@userdetail = Userdetail.new(params[:userdetail])
	    if @userdetail.save
			  flash[:success_msg] = t("general.profile_updated_successfully")
		   	  redirect_to fronts_path
		else
		  @o_userProvider = UserProvider.find(session[:user_provider_id].id)
		  render :action => 'mobile_edit'
		end
	end
  end




  def mobile_update_macros
@userdetail = Userdetail.new(params[:userdetail])
@userdetail.save
  
@content_value = "<b>" + @userdetail.desc + "</b><br /><b>Address:</b>" + @userdetail.address + "<br /><b>Open Hours:</b>" + @userdetail.office_hour + "<br /><b>Call Us Now:</b> <a href='tel:" + @userdetail.phone + "'>" + @userdetail.phone + "</a>	or <br /><a href='mailto:" + @userdetail.email + "'><b>send us email at: </b>" + @userdetail.email + "</a>"
			  @o_single = Page.new
			  @o_single.user_id = session[:user_provider_id].id
			  @o_single.provider = session[:user_provider]			  
			  @o_single.title = @userdetail.url + " " + @userdetail.desc
			  @o_single.content = @content_value
			  @o_single.url = @userdetail.url
			  @o_single.link_text = t("general.full_desktop_site")
			  @o_single.save

			#write javascript file start
				secure_code = SecureRandom.hex(15)
				source = File.read(Rails.public_path + "/javascripts/mobile/redirection_mobile.js")
				directory_file = Rails.public_path + "/uploads/jsfiles/" + secure_code+".js"
				#target = File.open( directory_file , "w")
				#target.write( source )
				target = File.open(directory_file, 'w') {|f| f.write(@source) }

	@base_mobile_url = "'" + BASE_URL_DOMAIN + "/show_page/" + @o_single.id.to_s + "?burl='+base_url"
	doc = "SA.redirection_mobile ({ noredirection_param: 'noredirection', mobile_url : "+@base_mobile_url+", mobile_prefix : 'https', cookie_hours : '2' });"

				File.open(directory_file, 'a') {|f| f.write(doc) }

				secure_file_name = 'u/social/'+session[:user_provider_id].id.to_s+'/'+secure_code+'.js'
				bucket_name = 'pagender'
				source_filename = directory_file
				s3 = AWS::S3.new.buckets['pagender'].objects[secure_file_name]
				s3.write(:file => source_filename, :acl => :public_read)

				File.delete(directory_file)

				@o_single.amazon_path = secure_file_name
				@o_single.save
			#write javascript file end


		   	  redirect_to edit_content_path(@o_single)
  end


  def forgot_password
	@user = User.new
	if !params[:user].blank?
		if params[:user][:email].blank?
			flash[:error_msg] = t("general.email_required")
			redirect_to :action => "forgot_password"
		elsif user = authenticate_password(params[:user][:email])
			new_pass = SecureRandom.hex(5)
		    user.password = new_pass
		    user.password_confirmation = new_pass
			user.save
			body = render_to_string(:partial => "fronts/forgot_password_mail", :locals => { :username => user.username, :new_pass => new_pass }, :formats => [:html])
			body = body.html_safe
			UserMailer.forgot_password_confirmation(user, new_pass, body).deliver
	  		flash[:success_msg] = t("general.password_has_been_sent_to_your_email_address")
			redirect_to fronts_path
		else
	  		flash[:error_msg] = t("general.no_user_exists_for_provided_email_address")
			redirect_to :action => "forgot_password"
		end
	end
  end	

  def change_password
	if !params[:user].blank?
		if params[:user][:password].blank?
			flash[:error_msg] = t("general.password_required")
			redirect_to :action => "change_password"
		elsif params[:user][:password].to_s != params[:user][:password_confirmation].to_s
			flash[:error_msg] = t("general.password_does_not_match")
			redirect_to :action => "change_password"
		else
			@user = User.find(current_user.id)
			@user.password = params[:user][:password]
			@user.password_confirmation = params[:user][:password_confirmation]
			if @user.save
			  flash[:success_msg] = t("general.password_successfully_updated")
			  redirect_to fronts_path
			else
			  flash[:success_msg] = t("general.password_does_not_updated")
			  render :action => :change_password
			end
		end
	else
		@user = User.new
	end
  end

  def facebook_login
      	auth_hash = request.env['omniauth.auth']
	  if session[:user_id]
	  else
		user_provider_id = Authorization.find_or_create(auth_hash)
		# Create the session
		session[:user_id] = user_provider_id
		session[:user_provider_id] = user_provider_id
		session[:user_provider] = auth_hash["provider"]
		session[:fb_token] = auth_hash["credentials"]["token"]
	 	
		#render :text => "Welcome #{auth.inspect}!"
	  end
	  if session[:user_id]
		@user = UserProvider.find(session[:user_provider_id].id)
		if @user && @user.is_active == false
			session[:user_id] = nil
			session[:user_provider_id] = nil
		    	session[:user_provider] = nil			
		    	flash[:error_login] = t("general.inactive_user")
		end
	  end
	  redirect_to fronts_path
	  
  end	

  def destroy
    @user_session = UserSession.find
	if @user_session
	    @user_session.destroy
	end
	session[:user_id] = nil
	if session[:user_provider].nil?
		redirect_to fronts_path
	else
		if session[:user_provider] == 'facebook'
			session[:user_provider_id] = nil
		    session[:user_provider] = nil
			base_url = BASE_URL
			redirect_to "https://www.facebook.com/logout.php?access_token=" + session[:fb_token] + "&next=#{base_url}"
		else
			session[:user_provider_id] = nil
		    session[:user_provider] = nil
			redirect_to fronts_path
		end
	end
  end

  def privacypolicy
  end

  def contactus
  end

  def terms
  end

  def content
	@o_single = Page.find(params[:id])
	if params[:page]
    	if @o_single.update_attributes(params[:page])
      		flash[:success_msg] = t("general.successfully_updated")
      		redirect_to fronts_path
		end
	end
  end
  def content_show
	@o_single = Page.find(params[:id])
	@o_single.view_count = @o_single.view_count + 1
	@o_single.save
  end
end
