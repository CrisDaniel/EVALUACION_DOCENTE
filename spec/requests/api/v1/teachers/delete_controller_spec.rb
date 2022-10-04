require 'swagger_helper'

RSpec.describe Api::V1::Users::TeachersController, type: :request do
  include_context 'user_stuff'
  describe 'Elimina un docente' do
    path '/api/v1/users/teachers/{teacher_id}' do
      delete 'Elimina un docente' do
        tags 'Teachers'
        description 'Retorna un mensaje de success si el docente se elimino con éxito.'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :teacher_id, in: :path

        response 200, 'Success!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    message: {type: :string}
                  }
          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:teacher_id) { user_teacher.id }

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
                    message: {type: :string}
                  }
          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:teacher_id) { 100 }

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
          let(:teacher_id) { user_teacher.id }

          run_test!
        end

      end
    end
  end
end