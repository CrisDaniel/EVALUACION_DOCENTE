class Api::V1::CoursesController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  # GET /api/v1/courses?q=search&order_by=ASC&page=number_page 
  def index
    policy.can_read?

    service = Courses::List.new(courses: Course.all, data: params)
    render json: service.call, status: :ok
  end

  # GET /api/v1/courses/:course_id
  def show
    policy.can_read?
    
    course = Course.find(params[:course_id])
    render json: { success: true, data: CourseSerializer.new(course), message: "Curso encontrado" }, status: :ok
  end

  # POST /api/v1/courses
  def create
    policy.can_write?

    service = Courses::Create.new(data: allowed_params)
    json_response = service.call
    render json: json_response, status: json_response[:code].to_s.to_sym
  end

  # PATCH /api/v1/courses/:course_id
  def update
    policy.can_write?

    service = Courses::Update.new(course_id: params[:course_id], data: allowed_params)
    json_response = service.call
    render json: json_response, status: json_response[:code].to_s.to_sym
  end

  # DELETE /api/v1/courses/:course_id
  def destroy
    policy.can_write?

    course = Course.find(params[:course_id])
    course.destroy!
    render json: { success: true, message: 'Se retiro el curso con exito!'}, status: :ok
  end

  private

  def policy
    CoursePolicy.new(user: current_user)
  end

  def allowed_params
    params.require(:course).permit!
  end
end