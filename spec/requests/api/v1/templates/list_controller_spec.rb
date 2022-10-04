require 'swagger_helper'

RSpec.describe Api::V1::TemplatesController, type: :request do
  include_context 'user_stuff'

  describe 'Retorna la lista de Templates' do
    path '/api/v1/templates' do
      get 'Retorna una lista de Templates' do
        tags 'Templates'
        description 'Retorna una lista de todos los templates y pueden ser filtrados por: <br/><br/> q = este es el search que busca por "name" <br/><br/> order_by = ordena por el campo "name" y soport "ASC" y "DESC" <br/><br/> page = Numero de pagina a mostrar'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :q, in: :query, required: false, type: :string
        parameter name: :order_by, in: :query, required: false, type: :integer
        parameter name: :page, in: :query, required: false, type: :integer

        response 200, 'success!!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    data: {
                      type: :object,
                      properties: {
                        per_page: { type: :integer },
                        total_pages: { type: :integer },
                        total_objects: { type: :integer },
                        current_page: { type: :integer },
                        templates: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              id: { type: :integer },
                              code: { type: :string },
                              name: { type: :string },
                              status: { type: :string },
                            }
                          }
                        }
                      }
                    },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(current_user, {}) }

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