class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.integer :senderId
      t.integer :receiverId
      t.decimal :amount
      t.date :timeStamp

      t.timestamps
    end
  end
end
