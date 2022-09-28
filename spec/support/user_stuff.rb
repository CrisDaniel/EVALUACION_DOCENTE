shared_context 'user_stuff' do
  before(:each) do
    Warden.test_mode!
  end

  after(:each) do
    Warden.test_mode!
  end

  let!(:user_admin) {
    user = User.create!({
      code: 20100101,
      fullname: 'admin',
      email: 'admin@sead.com',
      password: '12345!',
      password_confirmation: '12345!'
    })

    user.add_role :admin
    user
  }

  let!(:user_teacher) {
    user = User.create!({
      code: 20100202,
      fullname: 'teacher',
      email: 'teacher@sead.com',
      password: '12345!',
      password_confirmation: '12345!'
    })

    user.add_role :teacher
    user
  }

  let!(:user_student) {
    user = User.create!({
      code: 20100303,
      fullname: 'student',
      email: 'student@sead.com',
      password: '12345!',
      password_confirmation: '12345!'
    })

    user.add_role :student
    user
  }

  let(:user_student_with_courses) {
    user = User.create!({
      code: 20100303,
      fullname: "student with courses",
      email: "student_with_courses@sead.com",
      password: "12345!",
      password_confirmation: "12345!",
      course_ids: [course.id, course_2.id]
    })

    user.add_role :student
    user
  }

  let(:user_teacher_with_courses) {
    user = User.create!({
      code: 20100304,
      fullname: "teacher with courses",
      email: "teacher_with_courses@sead.com",
      password: "12345!",
      password_confirmation: "12345!",
      course_ids: [course.id, course_2.id]
    })

    user.add_role :teacher
    user
  }

  let(:current_user) { User.find_by(email: 'admin@sead.com') }

end