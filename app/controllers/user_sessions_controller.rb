class UserSessionsController < ApplicationController
  before_action :validate_user, only: :destroy_session

  def create
    user = User.where(email: params[:email]).first
    message, status = if user && user.authenticate(params[:password])
        [{
          api_token: user.generate_api_token,
          user: {
            id: user.id,
            name: user.name,
            email: user.email
          }
        }, :ok]
      else
        [{
          error: "Email/password does not match"
        }, :unauthorized]
      end
    render json: message, status: status
  end

  def destroy_session
    current_user.destroy_api_token(request.headers['Authorization'])
    render json: { message: "Logout successful" }
  end
end
