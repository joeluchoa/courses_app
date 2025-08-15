class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale


  protected

  def configure_permitted_parameters
    # Permit the 'name' parameter for the sign-up form
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # Permit the 'name' parameter for the account update form
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def set_locale
    begin
      # if params[:locale] is nil then I18n.default_locale will be used
      I18n.locale = params[:locale]
    rescue
    end
  end
end
