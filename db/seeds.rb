# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create four Users for testing
User.create(fname: "Kate", lname: "Hudgeson", email: "kateh@gmail.com", username: "khudgeson", password: "Test12345", password_confirmation: "Test12345", isAdmin: false)
User.create(fname: "John", lname: "Smith", email: "jsmith@gmail.com", username: "jsmith", password: "Test12345", password_confirmation: "Test12345", isAdmin: false)
User.create(fname: "Sam", lname: "Collins", email: "samcollins@gmail.com", username: "scollins", password: "Test12345", password_confirmation: "Test12345", isAdmin: false)
User.create(fname: "Mark", lname: "Amber", email: "markamber@gmail.com", username: "mamber", password: "Test12345", password_confirmation: "Test12345", isAdmin: false)
