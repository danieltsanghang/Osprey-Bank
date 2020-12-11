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
    (User.all.size .. User.all.size + amount - 1).each do |id|
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
