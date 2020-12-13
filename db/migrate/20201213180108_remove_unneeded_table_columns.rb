class RemoveUnneededTableColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :accountNumber
    remove_column :transactions, :timeStamp
  end
end
