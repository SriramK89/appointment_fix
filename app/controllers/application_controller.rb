class ApplicationController < ActionController::API
  def validate_user
    puts request.headers['Authorization'] if params[:testing]
    @current_user = User.get_from_api_token(request.headers['Authorization'])
    puts "#{@current_user.class}" if params[:testing]
    render_invalid_user if @current_user.nil?
  end

  def current_user
    @current_user
  end

  private

    def render_invalid_user
      render json: { error: "Invalid API token" }, status: :unauthorized
    end
end
