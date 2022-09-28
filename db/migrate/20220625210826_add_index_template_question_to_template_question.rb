class AddIndexTemplateQuestionToTemplateQuestion < ActiveRecord::Migration[6.0]
  def change
    add_index :template_questions, [:template_id, :question_id], unique: true
  end
end
