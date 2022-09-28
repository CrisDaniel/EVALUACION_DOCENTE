shared_context "survey_stuff" do
  before(:each) do
    Warden.test_mode!
  end

  after(:each) do
    Warden.test_mode!
  end

  let(:survey_list) {
    all_courses = Course.all

    User.all_students.each_with_index do |student, index| 
      student.courses << all_courses[index]
    end

    User.all_teachers.each_with_index do |teacher, index| 
      teacher.courses << all_courses[index]
    end

    draft_template_with_questions.update(state: "published")

    Survey.all_published
  }

  let(:first_survey) {
    survey_list.first
  }

end