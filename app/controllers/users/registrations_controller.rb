class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token
  skip_before_action :check_user_token, only: [:create]
  include Exceptionable

  api :POST, '/users'
  param :user, Hash, :desc => 'User info' do
    param :email, String, required: true, desc: 'user email'
    param :password, String, required: true, desc: 'user password'
    param :password_confirmation, String, required: true, desc: 'user password confirmation'
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user.as_json(:only => [:id, :email, :access_token]), status: :created
    else
      render json: errors_for(user.errors), status: :unprocessable_entity
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
