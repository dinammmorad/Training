class Users::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token
  skip_before_action :check_user_token, only: [:create]

  api :POST, '/users/sign_in'
  param :user, Hash, :desc => 'User info' do
    param :email, String, required: true, desc: 'user email'
    param :password, String, required: true, desc: 'user password'
  end

  def create
    user_email = user_params[:email]
    user = User.find_by_email(user_email)

    if (user && user.valid_password?(params[:user][:password]))
      render_success(user)
    else
      render_error(I18n.t('user.messages.invalid_login'))
    end
  end

  def render_success(user)
    render json: user.as_json(:only => [:id, :email, :user_name, :access_token, :mobile]), status: :ok
  end

  def render_error(error)
    render json: {message: error}, status: :unprocessable_entity
  end


  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
