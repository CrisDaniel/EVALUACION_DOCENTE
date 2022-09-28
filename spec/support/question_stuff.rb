shared_context "question_stuff" do
  before(:each) do
    Warden.test_mode!
  end

  after(:each) do
    Warden.test_mode!
  end

  let!(:question) {
    question = Question.find_or_create_by(
      content: "1. Llena los datos indicados para crear un nuevo alumno."
    )

    question
  }
end