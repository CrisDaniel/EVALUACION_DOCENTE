class DropUserCourses < ActiveRecord::Migration[6.0]
  def change
    drop_table :user_courses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
