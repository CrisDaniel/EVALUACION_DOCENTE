class AddIndexToQuestion < ActiveRecord::Migration[6.0]
  def change
    add_index :questions, :content, unique: true
  end
end
