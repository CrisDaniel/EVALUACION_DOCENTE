require 'swagger_helper'

RSpec.describe Api::V1::Users::SurveysController, type: :request do
  include_context 'course_stuff'
  include_context 'user_stuff'
  include_context 'template_stuff'
  include_context 'survey_stuff'

  describe "Guarda las respuestas de una encuesta" do
    path "/api/v1/users/surveys/{id}" do
      patch "Guarda las respuestas de una encuesta" do
        tags "Surveys"
        description "Retorna un mensaje de success si las respuestas se agregaron con exito"
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :id, in: :path
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            survey: {
              type: :object,
              properties: {
                answers: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      question_id: { type: :integer },
                      point: { type: :integer }
                    }
                  }
                }
              }
            }
          }
        }

        response 200, "success!!" do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(user_student_with_courses, {}) }
          let(:id) { first_survey.id }
          let(:params){{
            survey: {
              answers: [
                {
                  question_id: 1,
                  point: 2,
                }
              ]
            }
          }}

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
          let(:id) { 1000 }
          let(:params){{
            survey: {
              answers: [
                {
                  question_id: 1,
                  point: 2,
                }
              ]
            }
          }}

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
            expect(body.key?('message')).to eq(true)
          end
        end

        response 401, 'Jwt error!!!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean, default: false },
                    message: { type: :string }
                  }

          let(:'Authorization') { 'Bearer tokenErroe-125' }
          let(:id) { first_survey.id }
          let(:params){{
            survey: {
              answers: [
                {
                  question_id: 1,
                  point: 2,
                }
              ]
            }
          }}

          run_test!
        end

      end
    end
  end
end
