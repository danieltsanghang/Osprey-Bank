# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# Create an admin
User.create!(
  id: 0,
  fname: "Alice",
  lname: "Williams",
  email: "alice.williams@gmail.com",
  username:"admin",
  password: "Password12345",
  password_confirmation: "Password12345",
  isAdmin: true,
  phoneNumber: 123456789,
  DOB: Date.new(1990, 10, 10),
  address: "London, United Kingdom"
)

# Create a user
User.create!(
  id: 1,
  fname: "Bob",
  lname: "Sacamano",
  email: "bob.sacamano@outlook.com",
  username:"seinfeld",
  password: "Password12345",
  password_confirmation: "Password12345",
  isAdmin: false,
  phoneNumber: 987654321,
  DOB: Date.new(1990, 10, 11),
  address: "New York, United States"
)
