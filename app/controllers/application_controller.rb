class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  if Rails.env.production?
    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, with: :render_500
    end
  end


  def render_500(exception)
    logger.info exception.backtrace.join("\n")
    @log=exception.backtrace.join("<br />\n")
    render template: 'errors/500', layout: 'layouts/application', status: 500
  end
end
