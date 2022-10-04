require 'swagger_helper'

RSpec.describe Api::V1::CoursesController, type: :request do
  include_context 'user_stuff'

  describe 'Registrar un Curso' do
    path "/api/v1/courses" do
      post 'Crea un nuevo Curso' do
        tags 'Courses'
        description 'Crea/Agrega un nuevo curso.'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :course_params, in: :body, schema: {
          type: :object,
          properties: {
            course: {
              type: :object,
              properties: {
                code: { type: :string },
                name: { type: :string }
              }
            }
          },
          required: ['code']
        }

        response 200, 'success!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   course: {
                     type: :object,
                     properties: {
                        id: { type: :integer },
                        code: { type: :string },
                        name: { type: :string }
                     }
                   }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:course_params){{
            course: {
              code: 'NNE',
              name: 'Economia'
            }
          }}

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(true)
            expect(response.status).to eq(200)
          end

        end

        response 400, 'error!!!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean, default: false },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(current_user, {} )}
          let(:course_params){{
            course: {
              name: 'course name'
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
          let(:course_params){{
            course: {
              code: 'NNE',
              name: 'Name course'
            }
          }}
          
          run_test!
        end

      end
    end
  end

end