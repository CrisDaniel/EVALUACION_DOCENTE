class CreateTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :templates do |t|
      t.string :code
      t.string :name
      t.integer :state

      t.timestamps
    end
  end
end
