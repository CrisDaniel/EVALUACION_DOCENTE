class AddIndexToCourse < ActiveRecord::Migration[6.0]
  def change
    add_index :courses, :code, unique: true
  end
end
