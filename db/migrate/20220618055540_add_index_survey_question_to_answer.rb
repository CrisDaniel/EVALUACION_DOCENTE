class AddIndexSurveyQuestionToAnswer < ActiveRecord::Migration[6.0]
  def change
    add_index :answers, [:survey_id, :question_id], unique: true
  end
end
