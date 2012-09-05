class UserMailer < ActionMailer::Base
  default :from => "admin@rails.com"
  
  def registration_confirmation(user, body)
    @user = user
    mail(:to => "#{user.email} <#{user.email}>", :subject => "New registration", :body => body, :content_type => "text/html")
  end

  def forgot_password_confirmation(user,new_pass, body)
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Password Reset", :body => body, :content_type => "text/html")
  end

end


