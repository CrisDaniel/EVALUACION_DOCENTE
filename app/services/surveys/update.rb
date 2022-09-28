class Surveys::Update < BaseService
  def initialize(survey_id:, data:)
    super(data: data)

    @survey_id = survey_id
  end

  def call
    # Cargar un mensaje de error diciendo que no se pueden mostrar encuestas completadas.
    survey = Survey.all_published.where.not(state: "completed").find(@survey_id)
    answers = data[:answers]

    validate_answers(answers, survey)

    {
      success: true,
      message: "Se guardo las respuestas con exito!"
    }
  end

  private

  def validate_answers(answers, survey)
    answers.each do |answer|
      answer_found = Answer.find_by(survey: survey, question_id: answer[:question_id])

      if answer_found
        answer_found.update(point: answer[:point])
      else
        Answer.create(
          survey: survey,
          question_id: answer[:question_id],
          point: answer[:point]
        )
      end
    end
  end

end