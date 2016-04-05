class DeveloperMailer < ActionMailer::Base
  default from: "zhangyd0214@gmail.com"

  def security_warning(email)
    mail(:to => email, :subject => "Welcome to My Awesome Site")
  end
end
