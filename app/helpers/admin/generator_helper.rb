module Admin::GeneratorHelper

def generateUsers(amount)
  (User.all.size .. User.all.size + amount).each do |id|
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
end

def generateAccounts(amount, range)
  (Account.all.size .. Account.all.size + amount).each do |id|
      Account.create!(
          id: id,
          user_id: rand(1..20),
          sortCode: Faker::Number.number(digits: 6),
          accountNumber: Faker::Number.number(digits: 8),
          balance: Faker::Number.number(digits: 7),
          currency: %w[USD GBP EUR].sample
      )
  end
end

end
