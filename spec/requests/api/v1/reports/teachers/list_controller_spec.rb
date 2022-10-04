require 'swagger_helper'

RSpec.describe Api::V1::Users::TeachersController, type: :request do
  include_context 'user_stuff'

  describe "Retorna la lista reporte de docentes" do
    path "/api/v1/reports/teachers" do
      get "Retorna la lista de reporte de docentes" do
        tags "Reports"
        description 'Retorna una lista de docentes y pueden ser filtrados por: <br/><br/> q = este es el search que busca por "fullname", "correo" <br/><br/> order_by = ordena por el campo "full_name" y soport "ASC" y "DESC" <br/><br/> page = Numero de pagina a mostrar'
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
                        teachers: {
                          type: :array,
                          items: {
                            type: :object,
                            properties: {
                              id: { type: :integer },
                              code: { type: :integer },
                              fullname: { type: :string },
                              email: { type: :string },
                              surveys: {
                                type: :object,
                                properties: {
                                  completed: { type: :integer },
                                  incompleted: { type: :integer }
                                }
                              },
                              categories: {
                                type: :object,
                                properties: {
                                  domain: { type: :number },
                                  methodology: { type: :number },
                                  relationship: { type: :number },
                                  puntuality: { type: :number },
                                  contents: { type: :number },
                                  dedication: { type: :number },
                                  discipline: { type: :number }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
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