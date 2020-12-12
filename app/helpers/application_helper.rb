module ApplicationHelper
  # Function used to render the 404 page
  def redirect_to_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404 # Render 404 page
  end

  # Render errors for the input object
  def error_messages_for(object)
    render(:partial => 'application/error_messages', :locals => {:object => object})
  end

  # Function used to pass the params to the URL for sorting, i.e. ?sort="date"&direction="asc"
  # Source used: Rails casts episode 228, link: http://railscasts.com/episodes/228-sortable-table-columns
  def sortable(col, title=nil)
    title ||= col.titleize
    css = col == sort_column ? "current #{sort_direction}" : nil
    direction = col == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, request.params.merge( :sort => col, :direction => direction ), { :class => css }
  end

  # Function used to sort either in ascending or descending order, source: Rails cast episode 228: http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def filter(things)

    if(sort_direction == 'asc')
      things = things.sort_by {|el| el[sort_column]} # Sort the ascending order
    else
      things = things.sort_by {|el| el[sort_column]} # Sort the descending order
      things = things.reverse
    end

    return things

  end



  def findCurrency(sender,reciever,direction)

    if(Account.find_by(:id => sender).nil?)
      return "USD"
    else
      return Account.find_by(:id => sender).currency
    end

  end

  def convert(money,currency)
    if(currency.nil? && params.has_key?(:account_id))
      currency = Account.find_by(params[:account_id])
    end

    if(currency.nil? && !params.has_key?(:account_id))
      currency = 'USD'
    end

    return money.exchange_to(currency).format
  end

  def convert_return_amount(money,currency)
    if(currency.nil? && params.has_key?(:account_id))
      currency = Account.find_by(params[:account_id])
    end

    if(currency.nil? && !params.has_key?(:account_id))
      currency = 'USD'
    end

    return BigDecimal(money.exchange_to(currency).fractional)
  end

  def generateUsers(amount)
    @limit = User.all.size
    (@limit .. (@limit + amount -1)).each do |id|
        User.create!(
            id: id,
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

  def generateAccounts(amount, newUsers)
    @limit = Account.all.size.to_i
    @userLimit = User.all.size.to_i
    (@limit .. (@limit + amount-1)).each do |id|
        Account.create!(
            id: id,
            user_id: User.find(rand((@userLimit - newUsers) .. (@userLimit -1))).id,
            sortCode: Faker::Number.number(digits: 6),
            accountNumber: Faker::Number.number(digits: 8),
            balance: Faker::Number.number(digits: 7),
            currency: %w[USD GBP EUR].sample
        )
    end
  end

  def generateTransactions(amount, id_range)
    @limit = Transaction.all.size.to_i
    @accountLimit = Account.all.size.to_i
    (@limit .. @limit + amount-1).each do |id|
        Transaction.create!(
          id: id,
          sender_id: Account.find(rand((@accountLimit - id_range ) .. (@accountLimit -1))).id,
          # money to random account that doesnt exist
          receiver_id: Faker::Number.number(digits: 4),
          amount: Faker::Number.between(from: 10, to: 99999),
          timeStamp: Faker::Date.backward(days: Faker::Number.number(digits: 4))
        )
      end
      @limit = Transaction.all.size.to_i
        (@limit .. @limit + amount -1).each do |id|
        Transaction.create!(
          id: id,
          # money from random account that doesnt exist
          sender_id: Faker::Number.number(digits: 4),
          receiver_id: Account.find(rand((@accountLimit - id_range ) .. (@accountLimit -1))).id,
          amount: Faker::Number.between(from: 10, to: 99999),
          timeStamp: Faker::Date.backward(days: Faker::Number.number(digits: 4))
        )
      end
  end

# for generating transaction data for a single user, # of transaction specificed
# is doubled, once for sent, once for recieve.
  def userGenerateTransaction(userID, amount)
    @limit = Transaction.all.size.to_i
    Account.where("user_id = #{userID}").each do |account_id|
        (@limit .. @limit + amount-1).each do |id|
          Transaction.create!(
            id: id,
            sender_id: account_id,
            receiver_id: Faker::Number.number(digits: 4),
            amount: Faker::Number.between(from: 10, to: 99999),
            timeStamp: Faker::Date.backward(days: Faker::Number.number(digits: 3))
          )
        end
        @limit = Transaction.all.size.to_i
        (@limit .. @limit + amount-1).each do |id|
          Transaction.create!(
            id: id,
            sender_id: Faker::Number.number(digits: 4),
            receiver_id: account_id,
            amount: Faker::Number.between(from: 10, to: 99999),
            timeStamp: Faker::Date.backward(days: Faker::Number.number(digits: 3))
          )
        end
    end
  end

end
