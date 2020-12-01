class RenameAmountInTransaction < ActiveRecord::Migration[6.0]
  def change
      remove_column :transactions, :amount, :decimal,{}
      change_table :transactions do |t|
      t.monetize :amount # Rails 4x and above
    end
  end
end
