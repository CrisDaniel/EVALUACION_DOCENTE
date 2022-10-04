require 'swagger_helper'

RSpec.describe Api::V1::CoursesController, type: :request do
  include_context 'user_stuff'
  include_context 'course_stuff'

  describe 'Elimina un Curso' do
    path '/api/v1/courses/{course_id}' do
      delete 'Elimina un curso' do
        tags 'Courses'
        description 'Retorna un mensaje de success si el curso se elimino con éxito.'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :course_id, in: :path

        response 200, 'Success!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    message: {type: :string }
                  }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:course_id) { course.id }

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

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:course_id) { 100 }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
            expect(body.key?('message')).to eq(true)
          end
        end

        response 401, 'JWT error!!!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean, default: false },
                    message: { type: :string }
                  }

          let(:'Authorization') { 'Bearer tokenError-125' }
          let(:course_id) { course.id }

          run_test!
        end

      end
    end
  end

end