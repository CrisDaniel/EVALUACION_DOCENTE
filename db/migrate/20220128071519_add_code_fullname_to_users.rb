class AddCodeFullnameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :fullname, :string
    add_column :users, :code, :integer
  end
end
