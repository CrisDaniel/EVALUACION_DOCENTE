class Api::V1::Reports::TeachersController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  # GET /api/v1/reports/teachers?q=search&order_by=ASC&page=number_page
  def index
    policy.can_write?

    service = Reports::Teachers::List.new(teachers: User.all_teachers, data: params)
    render json: service.call, status: :ok
  end

  private

  def policy
    ManagePolicy.new(user: current_user)
  end
end