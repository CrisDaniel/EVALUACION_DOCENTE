require 'swagger_helper'

RSpec.describe Api::V1::Users::SurveysController, type: :request do
  include_context 'course_stuff'
  include_context 'user_stuff'

  describe "Retorna la lista de encuestas de un estudiante" do
    path "/api/v1/users/surveys" do
      get "Retorna la lista de encuestas de un estudiante" do
        tags "Surveys"
        description "Retorna la lista de encuestas de un estudiante logeado"
        produces "application/json"
        parameter name: "Authorization", in: :header
        
        response 200, "success!!" do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    data: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          id: { type: :integer },
                          teacher: { type: :string },
                          course: {
                            type: :object,
                            properties: {
                              id: { type: :integer },
                              name: { type: :string },
                            }
                          },
                          state: { type: :string }
                        }
                      }
                    },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(user_student_with_courses, {}) }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(true)
            expect(response.status).to eq(200)
          end
        end

        response 401, 'JWT error!!!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean, default: false },
                    message: { type: :string }
                  }

          let(:'Authorization') { 'Bearer tokenError-125' }

          run_test!
        end
      end
    end
  end
end