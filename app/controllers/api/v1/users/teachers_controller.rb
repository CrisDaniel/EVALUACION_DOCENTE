class Api::V1::Users::TeachersController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  # GET /api/v1//users/teachers?q=search&order_by=ASC&page=number_page 
  def index
    policy.can_read?

    service = Teachers::List.new(teachers: User.all_teachers, data: params)
    render json: service.call, status: :ok
  end

  # GET /api/v1/users/teachers/:teacher_id
  def show
    policy.can_write?

    teacher = User.all_teachers.find(params[:teacher_id])
    render json: { success: true, data: UserSerializer.new(teacher), message: "Docente encontrado" }, status: :ok
  end

  # DELETE /api/v1/users/teachers/:teacher_id
  def destroy
    policy.can_write?

    teacher = User.all_teachers.find(params[:teacher_id].to_i)
    teacher.destroy!
    render json: { success: true, message: 'Se retiro al estudiante con éxito' }, status: :ok
  end

  private

  def policy
    TeacherPolicy.new(user: current_user)
  end
end