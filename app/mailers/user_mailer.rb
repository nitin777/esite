class UserMailer < ActionMailer::Base
  default :from => "admin@rails.com"
  
  def registration_confirmation(user, body)
    @user = user
    mail(:to => "#{user.email} <#{user.email}>", :subject => "New registration", :body => body, :content_type => "text/html")
	body_admin = "New user created with email id - " + user.email
    mail(:to => "#{ADMIN_EMAIL} <#{ADMIN_EMAIL}>", :subject => "New registration", :body => body_admin, :content_type => "text/html")
  end

  def reset_password_confirmation(user, body)
    mail(:to => "#{user.email} <#{user.email}>", :subject => "Password Reset", :body => body, :content_type => "text/html")
  end

end


