class UseDecimalForCurrency < ActiveRecord::Migration[6.0]
  def change
    change_column :accounts, :balance, :decimal
    change_column :transactions, :amount, :decimal
  end
end
