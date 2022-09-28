class DropJoinTableTemplateQuestions < ActiveRecord::Migration[6.0]
  def change
    drop_join_table :templates, :questions do |t|
      t.index [:template_id, :question_id]
      t.index [:question_id, :template_id]
    end
  end
end
