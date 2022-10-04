require 'swagger_helper'

RSpec.describe Api::V1::Users::TeachersController, type: :request do
  include_context 'user_stuff'
  include_context 'template_stuff'
  describe 'Elimina un template que nunca fue publicado' do
    path '/api/v1/templates/{template_id}' do
      delete 'Elimina un template que nunca fue publicado' do
        tags 'Templates'
        description 'Retorna un mensaje de success si el template se elimino con éxito.'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :template_id, in: :path

        response 200, 'Success!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    message: { type: :string }
                  }
          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:template_id) { draft_template.id }

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
          let(:template_id) { published_template.id }

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
          let(:template_id) { draft_template.id }

          run_test!
        end

      end
    end
  end
end