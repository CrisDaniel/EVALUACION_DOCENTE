shared_context "course_stuff" do
  before(:each) do
    Warden.test_mode!
  end

  after(:each) do
    Warden.test_mode!
  end

  let!(:course) {
    course = Course.create!({
      code: 'ZZQ',
      name: 'Literatura'
    })

    course
  }

  let!(:course_2) {
    course = Course.create!({
      code: 'HHR',
      name: 'Matematica'
    })

    course
  }

  let!(:course_3) {
    course = Course.create!({
      code: 'CCH',
      name: 'Contabilidad'
    })

    course
  }
end