class RenameBalanceInAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :currency, :string,{}
    remove_column :accounts, :balance, :string,{}

    change_table :accounts do |t|
      t.monetize :balance # Rails 4x and above
    end
  end
end
