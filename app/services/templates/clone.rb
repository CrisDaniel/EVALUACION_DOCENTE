class Templates::Clone < BaseService

  def initialize(template:)

    @template = template
  end

  def call
    new_template = Template.new(
      code: @template.code + "_clone",
      name: @template.name + "_clone",
      state: "draft"
    )

    if has_questions?
      template_questions = @template.template_questions
      new_template.template_questions << clone_template_questions(template_questions)
    end

    new_template.save!

    {
      success: true,
      template: TemplateSerializer.new(new_template),
      message: "Se clono el template con exito!"
    }
  end

  private

  def clone_template_questions(template_questions)
    template_questions = template_questions.map do |template_question|
      new_template_question = TemplateQuestion.new(
        question: template_question.question,
        order: template_question.order,
        category: template_question.category
      )
    end

    template_questions
  end

  def has_questions?
    return true unless @template.template_questions.size.zero?

    false
  end

end
