class PopulateRoles < ActiveRecord::Migration[6.0]
  def up
    %w[admin teacher student].each do |name|
      Role.create!(name: name)
    end
  end

  def down
    Role.delete_all
  end
end
