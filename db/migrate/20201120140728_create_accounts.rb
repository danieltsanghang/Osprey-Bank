class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.integer :userId
      t.integer :sortCode
      t.integer :accountNumber
      t.decimal :balance
      t.string :currency

      t.timestamps
    end
  end
end
