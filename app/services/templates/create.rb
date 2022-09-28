class Templates::Create < BaseService
  attr_accessor :data

  def initialize(data:)
    super(data: data)

    @data = data
  end

  def call
    template_questions = @data.delete("template_questions")
    template = Template.new(@data)
    
    unless template_questions.nil?
      template.template_questions << validate_template_questions(template_questions)
    end
    
    template.save!

    {
      success: true,
      template: TemplateSerializer.new(template),
      message: "Se creo el template con exito!"
    }
  end

  private

  def validate_template_questions(template_questions)
    template_questions = template_questions.map do |template_question|
      question = template_question.delete("question")
      question = Question.find_or_initialize_by(content: question["content"])
      
      template_question = TemplateQuestion.new(template_question)
      template_question.question = question      
      template_question
    end
    
    template_questions
  end
end