class ChangeTypeInAccounts < ActiveRecord::Migration[6.0]
  def change
    change_column :accounts, :balance, 'integer USING CAST(balance AS integer)'
  end
end
