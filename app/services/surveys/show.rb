class Surveys::Show < BaseService

  def initialize(survey_id:)
    @survey_id = survey_id
  end

  def call
    # Cargar un mensaje de error diciendo que no se pueden mostrar encuestas completadas.
    survey = Survey.all_published.where.not(state: "completed").find(@survey_id)
    template = Template.find(survey.template_id)

    {
      success: true,
      data: {
        id: survey.id,
        teacher: survey.teacher.fullname,
        course: {
          id: survey.course_id,
          name: survey.course.name
        },
        template_questions: serializer(template.template_questions),
      },
      message: "Encuesta encontrada"
    }
  end

  private

  def serializer(template_questions)
    ActiveModelSerializers::SerializableResource.new(
      template_questions,
      each_serializer: ::TemplateQuestionSerializer
    )
  end

end