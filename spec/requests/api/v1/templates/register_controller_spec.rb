require 'swagger_helper'

RSpec.describe Api::V1::TemplatesController, type: :request do
  include_context "user_stuff"

  describe "Crea un Template" do
    path "/api/v1/templates" do
      post "Crea un nuevo Template" do
        tags "Templates"
        description "Crea un nuevo template"
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
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

        response 200, 'success!!' do
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
          let(:template_params){{
            template: { 
              code: "TEST1", 
              name: "ETEST1",
              template_questions: [ 
                { 
                  order: 1, 
                  category: "domain", 
                  question: { 
                    content: "1. Quien llego primero? el huevo? o la gallina?" 
                  } 
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

        response 422, 'error!!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    message: { 
                      type: :array,
                      items: { type: :string }
                    }
                  }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:template_params){{
            template: { 
              code: "TEST1"
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

          let(:'Authorization') { 'Bearer tokenErroe-125' }
          let(:template_params){{
            template: { 
              code: "TEST1", 
              name: "ETEST1",
              template_questions: [ 
                { 
                  order: 1, 
                  category: "domain", 
                  question: { 
                    content: "1. Quien llego primero? el huevo? o la gallina?" 
                  } 
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