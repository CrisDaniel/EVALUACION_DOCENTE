class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { 
      success: true,
      message: "Login success!",
      user: UserSerializer.new(resource)
    }, status: 200
  end

  def respond_to_on_destroy
    head :ok
  end

end
