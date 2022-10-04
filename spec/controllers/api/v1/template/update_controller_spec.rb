require "rails_helper"

RSpec.describe Api::V1::TemplatesController, type: :controller do
  include_context 'user_stuff'
  include_context 'template_stuff'
  include_context 'question_stuff'

  describe "Update template" do
    describe "When add a new template question" do
      it "but this question exists" do
        request.headers["Authorization"]  = auth_bearer(current_user, {})
        request.headers["Content-Type"] = 'application/json'
        patch :update, params: {
          template_id: draft_template.id,
          template: {
            template_questions: [ 
              { 
                order: 1, 
                category: "domain", 
                question: {
                  content: question.content
                }
              }
            ]
          }
        }

        body = JSON.parse(response.body)
        expected_template_questions = body["template"]["template_questions"]
        expected_first_question = expected_template_questions.first["question"]

        expect(expected_first_question["content"]).to eq(question.content)
      end

      it "but this question don't exist" do
        new_question_content = "2. Las respuestas del docente frente a las preguntas del estudiante."

        request.headers["Authorization"]  = auth_bearer(current_user, {})
        request.headers["Content-Type"] = 'application/json'
        patch :update, params: {
          template_id: draft_template.id,
          template: {
            template_questions: [ 
              { 
                order: 1, 
                category: "domain", 
                question: {
                  content: new_question_content
                }
              }
            ]
          }
        }

        body = JSON.parse(response.body)
        expected_template_questions = body["template"]["template_questions"]
        expected_first_question = expected_template_questions.first["question"]

        expect(expected_first_question["content"]).to eq(new_question_content)
      end
    end

    describe "When delete some template question" do
      it "but deleted only one" do
        template_id = draft_template_with_questions.id
        template_questions = draft_template_with_questions.template_questions
        # Delete the first question
        deleted_template_question, *new_template_questions = template_questions
        new_template_questions = JSON.parse(new_template_questions.to_json)

        request.headers["Authorization"]  = auth_bearer(current_user, {})
        request.headers["Content-Type"] = 'application/json'
        patch :update, params: {
          template_id: draft_template_with_questions.id,
          template: {
            template_questions: new_template_questions
          }
        }

        body = JSON.parse(response.body)
        expected_template_questions = body["template"]["template_questions"]
        expected_template_question_ids = expected_template_questions.map{ |tq| tq["id"] }

        expect(expected_template_questions.size).to eq(template_questions.size - 1)
        expect(expected_template_question_ids).not_to include(deleted_template_question.id)
      end

      it "but deleting all" do
        request.headers["Authorization"]  = auth_bearer(current_user, {})
        request.headers["Content-Type"] = 'application/json'
        patch :update, params: {
          template_id: draft_template_with_questions.id,
          template: {
            code: "20220203", 
            name: "Encuesta 2022-II",
            template_questions: [ ]
          }
        }
        
        body = JSON.parse(response.body)
        expected_template_questions = body["template"]["template_questions"]

        expect(expected_template_questions).to be_empty
      end
    end

    it "When change to state to published" do
      previously_published = published_template

      request.headers["Authorization"]  = auth_bearer(current_user, {})
        request.headers["Content-Type"] = 'application/json'
        patch :update, params: {
          template_id: draft_template_with_questions.id,
          template: {
            code: "20220203", 
            name: "Encuesta 2022-II",
            state: "published"
          }
        }
        
        body = JSON.parse(response.body)
        expected_template_state = body["template"]["state"]
        previously_published.reload

        expect(previously_published.state).to eq("archived")
        expect(expected_template_state).to eq("published")
    end
  end

end