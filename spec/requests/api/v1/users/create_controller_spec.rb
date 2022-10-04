require 'swagger_helper'

RSpec.describe Api::V1::Users::ManageController, type: :request do
  include_context 'role_stuff'
  include_context "course_stuff"
  include_context 'user_stuff'

  describe 'Registra un usuario' do
    path "/api/v1/users" do
      post 'Crea un nuevo usuario [ student || teacher ]' do
        tags 'Users'
        description 'Retorna un mensaje de success si el usuario se creo con exito. <br/><br/> Roles permitidos [ student || teacher ]'
        consumes 'application/json'
        produces 'application/json'
        parameter name: 'Authorization', in: :header
        parameter name: :params_user, in: :body, schema: {
          type: :object,
          properties: {
            user: {
              type: :object,
              properties: {
                code: { type: :integer },
                fullname: { type: :string },
                email: { type: :string },
                role_name: { type: :string },
                course_ids: {
                  type: :array,
                  items: { type: :integer },
                  description: "Courses List",
                  required: false
                }
              }
            }
          },
          required: [ 'code', 'email', 'role_name']
        }

        response 200, 'success!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean },
                   code: { type: :string },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:params_user){{
            user: {
              code: 123213,
              fullname: 'test',
              email: 'test@gmail.com', 
              role_name: student_role.name,
              course_ids: [ course.id, course_2.id ]
            }
          }}
            
          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(true)
            expect(response.status).to eq(200)
          end
        end

        response 400, 'error!!!' do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   code: { type: :string },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }

          # User without role
          let(:params_user){{
            user: {
              code: 123213,
              fullname: 'test',
              email: 'test@gmail.com', 
              role_name: '',
              course_ids: [ course.id, course_2.id ]
            }
          }}

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
            expect(body.key?('message')).to eq(true)
          end

          # User without email or code
          let(:params_user){{
            user: {
              code: nil,
              fullname: 'test',
              email: '', 
              role_name: teacher_role.name,
              course_ids: [ course.id, course_2.id ]
            }
          }}

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(body.dig('success')).to eq(false)
            expect(body.key?('message')).to eq(true)
          end

        end

        response 404, "Not found" do
          schema type: :object,
                 properties: {
                   success: { type: :boolean, default: false },
                   code: { type: :string },
                   message: { type: :string }
                 }

          let(:'Authorization') { auth_bearer(current_user, {}) }

          # User with all the courses that do not exist
          let(:params_user){{
            user: {
              code: 123213,
              fullname: "test",
              email: "test@gmail.com", 
              role_name: student_role.name,
              course_ids: [ 20000, 10000 ]
            }
          }}

          run_test! do |response|
            body = JSON.parse(response.body)
            expect(response).to have_http_status(:not_found)
          end
        end

        response 401, 'Jwt error!!!' do
          schema type: :object,
                  properties: {
                    success: { type: :boolean, default: false },
                    message: { type: :string }
                  }

          let(:'Authorization') { 'Bearer tokenErroe-125' }
          let(:params_user){{
            user: {
              code: 123213,
              fullname: 'test',
              email: 'test@gmail.com', 
              role_name: teacher_role.name
            }
          }}
          
          run_test!
        end

      end
    end
  end

end