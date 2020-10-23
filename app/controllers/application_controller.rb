class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def after_sign_in_path_for(resource)
    if current_user
        flash[:notice] = "Signed in successfully."
        user_path(current_user.id)
    else
        flash[:notice] = "Welcome! You have signed up successfully."
        user_path(current_user.id)
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
    :email,
    :name,
    :postcode,
    :prefecture_name,
    :address_city,
    :address_street,
    :address_building
    ])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:name])
  end

end
