require 'swagger_helper'

RSpec.describe Api::V1::Users::TeachersController, type: :request do
  include_context "course_stuff"
  include_context "user_stuff"

  describe "Retorna un docente" do
    path "/api/v1/users/teachers/{teacher_id}" do
      get "Retorna un docente" do
        tags "Teachers"
        description "Retorna los datos de un docente si es encontrado"
        produces "application/json"
        parameter name: 'Authorization', in: :header
        parameter name: :teacher_id, in: :path

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
          let(:teacher_id) { user_teacher_with_courses.id }

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
          let(:teacher_id) { 100 }

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
          let(:teacher_id) { user_teacher_with_courses.id }

          run_test!
        end

      end
    end
  end

end