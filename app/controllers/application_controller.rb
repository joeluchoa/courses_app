class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Permit the 'name' parameter for the sign-up form
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # Permit the 'name' parameter for the account update form
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
