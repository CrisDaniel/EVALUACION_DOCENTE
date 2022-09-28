class Templates::Update < BaseService
  attr_accessor :data

  def initialize(template_id:, data:)
    super(data: data)

    @template_id = template_id
    @template = template
    @template_questions_ids = []
  end

  def call
    template_questions = data.delete("template_questions")

    unless template_questions.nil?
      template_questions = validate_update(template_questions)
      validate_delete(template_questions)
    end

    @template.update(data)

    {
      success: true,
      template: TemplateSerializer.new(template),
      message: "Se actualizo el template!"
    }
  end

  private

  def validate_delete(template_questions)
    delete_tq_ids = @template.template_questions.map(&:id) - @template_questions_ids

    delete_tq_ids.map do |delete_tq_id|
      @template.template_questions.find(delete_tq_id).delete
    end

    @template.template_questions.reload
    delete_tq_ids
  end

  def validate_update(template_questions)
    template_questions.map do |template_question|
      if template_question[:id].present?
        update_template_question(template_question)
      else
        create_template_question(template_question)
      end
    end

    template_questions
  end
  
  def update_template_question(template_question)
    question = template_question.delete("question") 
    
    find_template_question = @template.template_questions.find_by(id: template_question[:id])
    find_template_question.update!(template_question)

    # CONTEXT: This is used to collect the ids and compare if any were removed
    @template_questions_ids << find_template_question.id
  end
  
  def create_template_question(template_question)
    question = template_question.delete("question")
    question = Question.find_or_initialize_by(content: question[:content])

    template_question = TemplateQuestion.new(template_question)
    template_question.question = question
    template_question.template = @template
    template_question.save!

    # CONTEXT: This is used to collect the ids and compare if any were removed
    @template_questions_ids << template_question.id
  end
  
  def has_question?(template_question)
    template_question[:question].present?
  end

  def template
    @template ||= Template.all_draft.find_by!(id: @template_id)
  end
end