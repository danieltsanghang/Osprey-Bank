module Admin::GeneratorHelper

def generateUsers(amount)
  (User.all.size .. User.all.size + amount).each do |id|
      User.create!(
          # id: id, # each user is assigned an id from 1-20
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
          user_id: rand(User.all.size - range .. User.all.size),
          sortCode: Faker::Number.number(digits: 6),
          accountNumber: Faker::Number.number(digits: 8),
          balance: Faker::Number.number(digits: 7),
          currency: %w[USD GBP EUR].sample
      )
  end
end

def generateTransactions(amount, range)
  (Transaction.all.size .. Transaction.all.size + amount).each do |id|
      Transaction.create!(
        sender_id: Account.find(rand(Account.all.size - range .. Account.all.size)).id,
        receiver_id: Account.find(rand(0 .. Account.all.size - range)).id,
        amount: Faker::Number.number(digits: 4),
        timeStamp: Faker::Date.backward(days: 100)
      )
      Transaction.create!(
        sender_id: Account.find(rand(0 .. Account.all.size - range)).id,
        receiver_id: Account.find(rand(Account.all.size - range .. Account.all.size)).id,
        amount: Faker::Number.number(digits: 4),
        timeStamp: Faker::Date.backward(days: 100)
      )
    end
end



end
