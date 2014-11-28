class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # authorize models
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User) #&& resource.can_publish?
        jobs_url
      else
        super
      end
  end  

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :name
    end

  private

    def user_not_authorized
     flash[:error] = I18n.translate(:no_sufficient_permissions, url: request.url + "#" + params[:action])
     redirect_to(request.referrer || root_path)
    end
   

  
end
