module TokenAuth
  def check_user_token
    render json: {message: 'not authenticated'}, status: :unauthorized unless is_user_authenticated
  end

  def is_user_authenticated
    (params[:access_token] && current_user)
  end

  def current_user
    @current_user = User.where(:access_token => params[:access_token]).first
  end
end
