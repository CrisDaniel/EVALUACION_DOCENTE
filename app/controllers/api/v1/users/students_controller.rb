class Api::V1::Users::StudentsController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  # GET /api/v1/users/students?q=search&order_by=ASC&page=number_page 
  def index
    policy.can_read?

    service = Students::List.new(students: User.all_students, data: params)
    render json: service.call, status: :ok
  end

  # GET /api/v1/users/students/:student_id
  def show
    policy.can_write?

    student = User.all_students.find(params[:student_id])
    render json: { success: true, data: UserSerializer.new(student), message: "Estudiante encontrado" }, status: :ok
  end

  # DELETE /api/v1/users/students/:student_id
  def destroy
    policy.can_write?

    student = User.all_students.find(params[:student_id])
    student.destroy!
    render json: { success: true, message: 'Se retiro al estudiante con éxito' }, status: :ok
  end

  private

  def policy
    StudentPolicy.new(user: current_user)
  end

end