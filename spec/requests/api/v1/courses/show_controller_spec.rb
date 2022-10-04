require 'swagger_helper'

RSpec.describe Api::V1::CoursesController, type: :request do
  include_context 'course_stuff'
  include_context 'user_stuff'

  describe "Retorna un Curso" do
    path "/api/v1/courses/{course_id}" do
      get "Retorna un curso" do
        tags "Courses"
        description "Retorna un curso si el curso es encontrado"
        produces "application/json"
        parameter name: 'Authorization', in: :header
        parameter name: :course_id, in: :path

        before do
          user_teacher_with_courses
        end

        response 200, "success!!" do
          schema type: :object,
                  properties: {
                    success: { type: :boolean },
                    data: { 
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        code: { type: :string },
                        name: { type: :string },
                        teacher: { type: :string }
                      }
                    },
                    message: { type: :string }
                  }

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:course_id) { course.id }

          run_test! do |response|
            body = JSON.parse(response.body)
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

          let(:'Authorization') { auth_bearer(current_user, {}) }
          let(:course_id) { 100 }

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
          let(:course_id) { course.id }

          run_test!
        end

      end
    end
  end

end