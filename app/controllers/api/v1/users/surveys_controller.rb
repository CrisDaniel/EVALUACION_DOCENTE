class Api::V1::Users::SurveysController < ApplicationController
  before_action :authenticate_user!
  respond_to :json

  # GET /api/v1/users/students/surveys
  def index
    policy.can_write?

    student = User.all_students.find(current_user.id)
    surveys = student.student_surveys.all_published
    render json: { success: true, data: serializer(surveys), message: "Success!" }, status: :ok
  end

  # GET /api/v1/users/students/surveys/:id
  def show
    policy.can_read?

    service = Surveys::Show.new(survey_id: params[:id])
    render json: service.call, status: :ok
  end

  # GET /api/v1/users/students/surveys/:id
  def update
    policy.can_write?

    service = Surveys::Update.new(survey_id: params[:id], data: allowed_params)
    render json: service.call, status: :ok
  end

  private

  def policy
    SurveyPolicy.new(user: current_user)
  end

  def serializer(surveys)
    ActiveModelSerializers::SerializableResource.new(
      surveys,
      each_serializer: ::SurveySerializer
    )
  end

  def allowed_params
    params.require(:survey).permit(answers: [:question_id, :point])
  end
end