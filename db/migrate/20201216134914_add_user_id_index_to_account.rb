class AddUserIdIndexToAccount < ActiveRecord::Migration[6.0]
  def change
    add_index :accounts, :user_id
  end
end
