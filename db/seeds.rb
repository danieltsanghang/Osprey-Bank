# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
require 'faker'

tables = ActiveRecord::Base.connection.tables - ['schema_migrations']

tables.each do |table|
  ActiveRecord::Base.connection.execute "DELETE FROM #{table}"
  # ActiveRecord::Base.connection.execute "ALTER TABLE #{table} AUTO_INCREMENT = 1" for special cases this might be used.
end

User.create!(
  id: 0,
  fname: "dev",
  lname: "user",
  email: Faker::Internet.email,
  username:"development",
  password: "0000000000", # issue each user the same password
  password_confirmation: "0000000000",
  isAdmin: false,
  phoneNumber: Faker::Number.number(digits: 9),
  DOB: Faker::Date.in_date_period,
  address: Faker::Address.full_address
)
User.create!(
  id: 1,
  fname: "admin",
  lname: "user",
  email: Faker::Internet.email,
  username:"admin0",
  password: "0000000000", # issue each user the same password
  password_confirmation: "0000000000",
  isAdmin: true,
  phoneNumber: Faker::Number.number(digits: 9),
  DOB: Faker::Date.in_date_period,
  address: Faker::Address.full_address
)
(0..4).each do |id|
    Account.create!(
        id: Faker::Number.between(from: 10000000, to: 90000000),
        user_id: 0,
        sortCode: Faker::Number.number(digits: 6),
        # accountNumber: Faker::Number.number(digits: 8),
        balance: Faker::Number.number(digits: 7),
        currency: %w[USD GBP EUR].sample
    )
end


# generate 20 users
(2..20).each do |id|
    User.create!(
        id: id, # each user is assigned an id from 1-20
        fname: Faker::Name.unique.first_name,
        lname: Faker::Name.unique.last_name ,
        email: Faker::Internet.email,
        username: Faker::Internet.username(specifier: 6),
        password: "Password12345", # issue each user the same password
        password_confirmation: "Password12345",
        isAdmin: false,
        phoneNumber: Faker::Number.number(digits: 9),
        DOB: Faker::Date.in_date_period,
        address: Faker::Address.full_address
    )
end

(5..50).each do |id|
    Account.create!(
        id: Faker::Number.between(from: 10000000, to: 90000000),
        user_id: rand(1..20),
        sortCode: Faker::Number.number(digits: 6),
        balance: Faker::Number.number(digits: 7),
        currency: %w[USD GBP EUR].sample
    )
end

(0..100).each do |id|
    Transaction.create!(
      id: id,
      sender_id: Account.last(25).first.id,
      receiver_id: Account.first(25).first.id,
      amount: Faker::Number.number(digits: 4),
      created_at: Faker::Date.backward(days: 100)
    )
  end
