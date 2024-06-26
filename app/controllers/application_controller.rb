class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:sanitized_phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:sanitized_phone_number])
  end
end
