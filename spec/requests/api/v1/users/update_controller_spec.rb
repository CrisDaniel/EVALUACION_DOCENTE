require 'swagger_helper'

RSpec.describe Api::V1::Users::ManageController, type: :request do
  include_context "role_stuff"
  include_context "course_stuff"
  include_context "user_stuff"

  describe 'Actualizar un usuario' do
    path "/api/v1/users/{user_id}" do
      patch 'Actualiza un usuario' do
        tags 'Users'
        description 'Retorna un mensaje de success si el usuario se actualizo con exito'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :user_id, in: :path
        parameter name: :params_user, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                code: { type: :integer },
                email: { type: :string },
                fullname: { type: :string },
                course_ids: {
                  type: :array,
                  items: { type: :integer },
                  description: "Courses List",
                  required: false
                }
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
          
          # User updated name
          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:user_id) { user_student.id }
          let(:params_user){{
            user: {
              fullname: 'updateName',
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

          # When not found user_id
          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:user_id) { 100 }
          let(:params_user){{
            user: {
              fullname: 'updateName',
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
          let(:user_id) { user_student.id }
          let(:params_user){{
            user: {
              code: 20100501,
              fullname: 'test!',
              email: 'test@gmail.com'
            }
          }}

          run_test!
        end
      
      end
    end
  end

end