require 'swagger_helper'

RSpec.describe Api::V1::Users::SurveysController, type: :request do
  include_context 'course_stuff'
  include_context 'user_stuff'
  include_context 'template_stuff'
  include_context 'survey_stuff'

  describe "Retorna una encuesta" do
    path "/api/v1/users/surveys/{id}" do
      get "Retorna una encuesta" do
        tags "Surveys"
        description "Retorna una encuesta si esta publicada </br> Si la encuesta ya fue completada no retornara nada"
        produces "application/json"
        parameter name: 'Authorization', in: :header
        parameter name: :id, in: :path

        response 200, "success!!" do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    data: {
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
                        template_questions: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              id: { type: :integer },
                              order: { type: :integer },
                              category: { type: :string },
                              question: {
                                type: :object,
                                properties: {
                                  id: { type: :integer },
                                  content: { type: :string }
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    message: { type: :string }
                  }
        
          let(:'Authorization') { auth_bearer(user_student_with_courses, {}) }
          let(:id) { first_survey.id }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(true)
            expect(response.status).to eq(200)
          end
        end

        response 404, 'Not Found!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(user_student_with_courses, {}) }
          let(:id) { 10000 }

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
          let(:id) { first_survey.id }

          run_test!
        end

      end
    end
  end
end