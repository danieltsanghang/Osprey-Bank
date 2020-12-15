class AccountAutoIncrementIdFromLargeNumber < ActiveRecord::Migration[6.0]
  def change
    execute("ALTER SEQUENCE accounts_id_seq START with 1000 RESTART;")
  end
end
