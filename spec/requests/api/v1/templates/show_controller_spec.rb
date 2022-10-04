require 'swagger_helper'

RSpec.describe Api::V1::CoursesController, type: :request do
  include_context 'user_stuff'
  include_context 'template_stuff'

  describe "Retorna un Template" do
    path "/api/v1/templates/{template_id}" do
      get "Retorna un Templae" do
        tags "Templates"
        description "Retorna un template si es encontrado"
        produces "application/json"
        parameter name: 'Authorization', in: :header
        parameter name: :template_id, in: :path

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
                        state: { type: :string },
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
                                  id: { type: :integer },
                                  content: { type: :string }
                                }
                              }
                            }
                          }
                        }
                      }
                    },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:template_id) { draft_template.id }

          run_test! do |response|
            body = JSON.parse(response.body)
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
          let(:template_id) { 100 }

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(response).to have_http_status(:not_found)
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