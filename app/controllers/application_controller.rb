class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Exceptionable
  include TokenAuth
  before_action :check_user_token

  #rescue from record not found exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  include ActionController::Serialization

  protected
  def render_errors(errors)
    render json: errors_for(errors), status: :unprocessable_entity
  end
end
