class ChangeColumnDefaultStateToTemplate < ActiveRecord::Migration[6.0]
  def change
    change_column_default :templates, :state, from: nil, to: 0
  end
end
