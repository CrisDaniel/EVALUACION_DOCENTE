require 'swagger_helper'

RSpec.describe Api::V1::Users::StudentsController, type: :request do
  include_context "course_stuff"
  include_context "user_stuff"

  describe "Retorna un estudiante" do
    path "/api/v1/users/students/{student_id}" do
      get "Retorna un estudiante" do
        tags "Students"
        description "Retorna los datos de un estudiante si es encontrado"
        produces "application/json"
        parameter name: 'Authorization', in: :header
        parameter name: :student_id, in: :path

        before do
          user_teacher_with_courses
        end

        response 200, "success!!" do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    data: { 
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        code: { type: :integer },
                        fullname: { type: :string },
                        email: { type: :string },
                        role: { type: :string },
                        courses: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              id: { type: :integer },
                              code: { type: :string },
                              name: { type: :string },
                              teacher: { type: :string }
                            }
                          }
                        }
                      }
                    },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:student_id) { user_student_with_courses.id }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(response).to have_http_status(:ok)
          end
        end

        response 404, 'Not Found!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   code: { type: :string },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:student_id) { 100 }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(response).to have_http_status(:not_found)
          end
        end

        response 401, 'JWT error!!!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean, default: false },
                    message: { type: :string }
                  }

          let(:'Authorization') { 'Bearer tokenError-125' }
          let(:student_id) { user_student_with_courses.id }

          run_test!
        end

      end
    end
  end

end