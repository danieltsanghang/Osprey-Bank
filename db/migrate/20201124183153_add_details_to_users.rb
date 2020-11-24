class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  # add additional fields to the users table
  def change
    add_column :users, :DOB, :Date
    add_column :users, :phoneNumber, :int
  end
end
