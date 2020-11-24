class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :DOB, :Date
    add_column :users, :phoneNumber, :int
  end
end
