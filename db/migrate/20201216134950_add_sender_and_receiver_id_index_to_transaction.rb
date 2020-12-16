class AddSenderAndReceiverIdIndexToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_index :transactions, :sender_id
    add_index :transactions, :receiver_id
  end
end
