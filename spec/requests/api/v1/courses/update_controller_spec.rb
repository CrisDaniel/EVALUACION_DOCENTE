require 'swagger_helper'

RSpec.describe Api::V1::CoursesController, type: :request do
  include_context 'user_stuff'
  include_context 'course_stuff'

  describe 'Actualizar un curso' do
    path "/api/v1/courses/{course_id}" do
      patch 'Actualiza un curso' do
        tags 'Courses'
        description 'Retorna un mensaje de success si el curso se actualizo con exito'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :course_id, in: :path
        parameter name: :params_course, in: :body, schema: {
          type: :object,
          properties: {
            course: {
              type: :object,
              properties: {
                code: { type: :integer },
                name: { type: :string }
              }
            }
          }
        }

        response 200, 'success!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   code: { type: :string },
                   message: { type: :string }
                 }
          
          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:course_id) { course.id }
          let(:params_course){{
            course: {
              name: 'updateName',
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
                   code: { type: :string },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:course_id) { 100 }
          let(:params_course){{
            course: {
              name: 'updateName',
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
          let(:course_id) { course.id }
          let(:params_course){{
            course: {
              code: 'NNNTUPD',
              name: 'test!'
            }
          }}

          run_test!
        end
      
      end
    end
  end

end