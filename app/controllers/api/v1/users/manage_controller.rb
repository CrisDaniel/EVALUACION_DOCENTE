class Api::V1::Users::ManageController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  # POST /api/v1/users
  def create
    policy.can_write?

    service = Users::Create.new(data: allowed_params)
    json_response = service.call
    render json: json_response, status: json_response[:code].to_s.to_sym
end

  # PATCH /api/v1/users/{user_id}
  def update
    policy.can_write?

    service = Users::Update.new(user_id: params[:user_id], data: allowed_params)
    json_response = service.call
    render json: json_response, status: json_response[:code].to_s.to_sym
  end

  private
  
  def policy
    ManagePolicy.new(user: current_user)
  end

  def allowed_params
    params.require(:user).permit(:code, :fullname, :email, :role_name, course_ids: [])
  end
end