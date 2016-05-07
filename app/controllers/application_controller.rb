class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :setup_organizations

  def setup_organizations
  	if current_user.present?
  		@organizations = current_user.organizations
  	end
  end
end
