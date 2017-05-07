class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::MimeResponds
  before_action :configure_permitted_parameters,  if: :devise_controller?
  before_action :configure_permitted_parameter, if: :devise_controller?
  
  protected 
    def configure_permitted_parameters
      added_attrs = [:nickname, :name]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    end
    def configure_permitted_parameter
      added_attrs = [:name, :nickname]
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end
end
