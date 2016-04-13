class DeveloperMailer < ActionMailer::Base
  default from: "Your Security Team"

  def security_warning(email, owner, dependencies, vulnerabilities)
  	@dependencies = dependencies
  	@vulnerabilities = vulnerabilities
  	@owner = owner
    mail(:to => email, :subject => "ATTN: Vulnerable Dependencies Found In Your Project")
  end
end
