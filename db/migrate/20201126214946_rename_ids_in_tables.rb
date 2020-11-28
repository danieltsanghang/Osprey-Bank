class RenameIDsInTables < ActiveRecord::Migration[6.0]
  def change
    rename_column :accounts, :userId, :user_id
    rename_column :transactions, :senderId, :sender_id
    rename_column :transactions, :receiverId, :receiver_id
  end
end
