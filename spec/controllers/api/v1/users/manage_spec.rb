require "rails_helper"

RSpec.describe Api::V1::Users::ManageController, type: :controller do
  include_context "role_stuff"
  include_context "course_stuff"
  include_context "user_stuff"

  describe "Create user" do
    it "with associated courses that exist" do
      request.headers["Authorization"]  = auth_bearer(current_user, {})
      post :create, params: {
        user: {
          code: 123213,
          fullname: "test",
          email: "test@gmail.com", 
          role_name: student_role.name,
          course_ids: [ course.id, course_2.id ]
        }
      }

      user = User.find_by(email: "test@gmail.com")

      expect(user.course_ids.size).to eq (2)
      expect(user.course_ids).to eq ([ course.id, course_2.id ])
    end

    it "with associated courses that exist but added many times" do
      request.headers["Authorization"]  = auth_bearer(current_user, {})
      post :create, params: {
        user: {
          code: 123213,
          fullname: "test",
          email: "test@gmail.com", 
          role_name: student_role.name,
          course_ids: [ course.id, course.id, course.id, course.id ]
        }
      }

      user = User.find_by(email: "test@gmail.com")

      expect(user.course_ids.size).to eq (1)
      expect(user.course_ids).to eq ([ course.id ])
    end

    it "with associated a course that do not exist" do
      request.headers["Authorization"]  = auth_bearer(current_user, {})
      post :create, params: {
        user: {
          code: 123213,
          fullname: "test",
          email: "test@gmail.com", 
          role_name: student_role.name,
          course_ids: [ course.id, 10000 ]
        }
      }

      user = User.find_by(email: "test@gmail.com")

      expect(user).to eq nil
      expect(response).to have_http_status(:not_found)
    end

    it "with associated courses that do not exist" do
      request.headers["Authorization"]  = auth_bearer(current_user, {})
      post :create, params: {
        user: {
          code: 123213,
          fullname: "test",
          email: "test@gmail.com", 
          role_name: student_role.name,
          course_ids: [ 20000, 10000 ]
        }
      }

      user = User.find_by(email: "test@gmail.com")

      expect(user).to eq nil
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "Update user" do
    it "with deleted a associated course" do
      request.headers["Authorization"]  = auth_bearer(current_user, {})
      patch :update, params: {
        user_id: user_student_with_courses.id,
        user: {
          course_ids: [ course.id ]
        }
      }

      updated_user = User.find(user_student_with_courses.id)

      expect(updated_user.course_ids.size).to eq (1)
      expect(updated_user.course_ids).to eq ([ course.id ])
    end

    it "with added associated courses that exists" do
      request.headers["Authorization"]  = auth_bearer(current_user, {})
      patch :update, params: {
        user_id: user_student_with_courses.id,
        user: {
          course_ids: [ course.id, course_2.id, course_3.id ]
        }
      }

      updated_user = User.find(user_student_with_courses.id)

      expect(updated_user.course_ids.size).to eq (3)
      expect(updated_user.course_ids).to eq ([ course.id, course_2.id, course_3.id ])
    end

    it "with added associated courses that exists but added many times" do
      request.headers["Authorization"]  = auth_bearer(current_user, {})
      patch :update, params: {
        user_id: user_student_with_courses.id,
        user: {
          course_ids: [ course.id, course.id, course.id, course.id ]
        }
      }

      updated_user = User.find(user_student_with_courses.id)

      expect(updated_user.course_ids.size).to eq (1)
      expect(updated_user.course_ids).to eq ([ course.id ])
    end

    it "with associated courses that do not exist" do
      request.headers["Authorization"]  = auth_bearer(current_user, {})
      patch :update, params: {
        user_id: user_student_with_courses.id,
        user: {
          course_ids: [ 10000, course_2.id, 2000 ]
        }
      }

      expect(response).to have_http_status(:not_found)
    end
  end
  
end