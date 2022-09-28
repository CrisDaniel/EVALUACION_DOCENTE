class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.string :content
      t.integer :category
      t.integer :order

      t.timestamps
    end
  end
end
