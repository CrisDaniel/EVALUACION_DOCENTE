class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    register_success(resource) && return if resource.persisted?

    register_failed(resource)
  end

  def register_success(resource)
    render json: { 
      success: true,
      message: 'Signed up sucessfully.' ,
      user: resource
    }, status: 200
  end

  def register_failed(resource)
    render json: { 
      success: false,
      message: resource.errors.full_messages.join(', '),
      user: resource
    }, status: 401
  end

end