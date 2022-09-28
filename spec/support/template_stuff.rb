shared_context "template_stuff" do
  before(:each) do
    Warden.test_mode!
  end

  after(:each) do
    Warden.test_mode!
  end

  let(:archived_tempate) {
    template = Template.find_or_create_by(
      code: "20220101",
      name: "Encuesta 2022-I",
      state: "archived"
    )

    template
  }

  let(:published_template) {
    template = Template.find_or_create_by(
      code: "20220201",
      name: "Encuesta 2022-II",
      state: "published"
    )

    template
  }


  let(:draft_template) {
    template = Template.find_or_create_by(
      code: "20220202", 
      name: "Encuesta 2022-II",
    )

    template
  }

  let(:draft_template_with_questions) {
    template = Template.find_or_create_by(
      code: "20220203", 
      name: "Encuesta 2022-II",
    )

    [
      "1. Llena los datos indicados para crear un nuevo alumno.",
      "2. Las respuestas del docente frente a las preguntas del estudiante.",
      "3. Llena los datos indicados para crear un nuevo alumno.",
    ].each_with_index do |content, index|
      question = Question.find_or_create_by(content: content)
      
      template_question = TemplateQuestion.find_or_create_by(
        order: index + 1,
        category: "domain", 
        question: question,
        template: template
      )

    end

    template
  }
end