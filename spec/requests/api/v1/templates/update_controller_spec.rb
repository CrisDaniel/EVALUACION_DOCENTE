require 'swagger_helper'

RSpec.describe Api::V1::CoursesController, type: :request do
  include_context 'user_stuff'
  include_context 'template_stuff'

  describe "Actualizar un template" do
    path "/api/v1/templates/{template_id}" do
      patch "Actualiza un template" do
        tags "Templates"
        description "Retorna el template actualizado </br></br>
                    Siempre que envie un `template_question.id` se asume que esta modificando solo sus propiedades `order` || `category` </br></br>
                    Si desea agregar/crear una nueva pregunta, puede enviarlo sin necesidad de pasarle un `template_question.id` </br></br>
                    Si intenta enviar una pregunta modificada, esta sera una pregunta nueva, por lo que recomendamos enviarlo sin la propiedad `template_question.id` </br>
                    de lo contrario retornara un error.</br></br> 
                    Si desea eliminar una pregunta que ya existe en el template, solo __*NO ENVIE*__ el `template_question` que desea eliminar </br></br>
                    
                    PD: Recuerde que solo podemos actualizar los templates que estan en 'draft'"
        consumes "application/json"
        produces "application/json"
        parameter name: "Authorization", in: :header
        parameter name: :template_id, in: :path
        parameter name: :template_params, in: :body, schema: {
          type: :object,
          properties: {
            template: {
              type: :object,
              properties: {
                code: { type: :string },
                name: { type: :string },
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
                          content: { type: :string }
                        }
                      }
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
                    template: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        code: { type: :string },
                        name: { type: :string },
                        state: { type: :string }
                      }
                    },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:template_id) { draft_template.id }
          let(:template_params){{
            template: {
              code: "012"
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
                    success: { type: :boolean },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:template_id) { 100 }
          let(:template_params){{
            template: {
              code: "012"
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
          let(:template_id) { draft_template.id }
          let(:template_params){{
            template: {
              code: "012"
            }
          }}

          run_test!
        end

      end
    end
  end

end