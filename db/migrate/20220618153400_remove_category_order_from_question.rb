class RemoveCategoryOrderFromQuestion < ActiveRecord::Migration[6.0]
  def change
    remove_column :questions, :category, :integer
    remove_column :questions, :order, :integer
  end
end
