class CreateSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.references :template, null: false, foreign_key: true
      t.integer :student_id, null: false
      t.integer :teacher_id, null: false
      t.references :course, null: false, foreign_key: true
      t.integer :state, default: 0

      t.timestamps
    end
    add_foreign_key :surveys, :users, column: :student_id
    add_foreign_key :surveys, :users, column: :teacher_id
  end
end
