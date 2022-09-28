class AddIndexToTemplate < ActiveRecord::Migration[6.0]
  def change
    add_index :templates, :code, unique: true
  end
end
