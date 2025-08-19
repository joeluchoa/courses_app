class AddRolesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :integer, default: 0 # 0 for operator
    add_column :users, :blocked_at, :datetime
  end
end
