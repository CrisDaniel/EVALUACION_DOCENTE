shared_context 'role_stuff' do
  before(:each) do
    Warden.test_mode!
  end

  after(:each) do
    Warden.test_mode!
  end

  
  let(:admin_role) { Role.find_or_create_by!(name: "admin") }

  let(:teacher_role) { Role.find_or_create_by!(name: "teacher") }

  let(:student_role) { Role.find_or_create_by!(name: "student")  }
end