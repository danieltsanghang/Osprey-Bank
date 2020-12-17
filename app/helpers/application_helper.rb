module ApplicationHelper
  # Function used to render the 404 page
  def redirect_to_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404 # Render 404 page
  end

  # Render errors for the input object
  def error_messages_for(object)
    render(:partial => 'application/error_messages', :locals => {:object => object})
  end

  # Generates title for each page dynamically
  def full_title(current_page_title = '')
    application_title = "Osprey Bank"
    if current_page_title.empty?
      application_title
    else
      "#{application_title} | #{current_page_title}"
    end
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

  # Filter through a list of objects
  def filter(things)
    # 'things' represents the list of objects to sort
    if(sort_direction == 'asc')
      things = things.sort_by {|el| el[sort_column]} # Sort the ascending order
    else
      things = things.sort_by {|el| el[sort_column]} # Sort the descending order
      things = things.reverse
    end

    return things

  end

  # Determine currency from sender, receiver and direction
  def findCurrency(sender,reciever,direction)

    if(Account.find_by(:id => sender).nil?)
      return "USD"
    else
      return Account.find_by(:id => sender).currency
    end

  end

  # Convert a money object to another currency based on the params and return the money object
  def convert(money,currency)
    valid_currencies = %w(GBP EUR USD)
    if(currency.nil? && params.has_key?(:account_id))
      currency = Account.find_by(params[:account_id])
    end

    if((currency.nil? && !params.has_key?(:account_id)) || !valid_currencies.include?(currency))
      currency = 'USD'
    end

    return money.exchange_to(currency).format
  end

  # Convert a money object to another currency based on the params and return the amount represented in cents
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
    @limit = 0
    if !User.first.nil?
        @limit = User.last.id.to_i + 1
    end

    (@limit .. (@limit + amount -1)).each do |id|
      companypostfix = ["LLC", "Group", "&Co", "Inc", "Corp", "Pte"].sample
      lastname = Faker::Name.last_name

      companyUserName = (lastname.dup << companypostfix)
      normalUserName = Faker::Internet.unique.username(specifier: 6)

      if(companyUserName.length < 6 || User.where("username ~* ?", companyUserName)) then
        companyUserName = companyUserName.dup << Faker::Number.number(digits: 2).to_s end

      if(companyUserName.length > 20 ) then
        companyUserName = normalUserName end

      normal = [Faker::Name.first_name, lastname, normalUserName]
      company = [lastname, companypostfix, companyUserName]
      detailUsed = [normal,company].sample
      account_ids = Array.new()
      puts ("!@!@!@!@!@!@!@!@!@!@!@!@!@!@@!!@")
      puts (companyUserName)
      puts (normalUserName)
        User.create!(
            id: id,
            fname: detailUsed[0],
            lname: detailUsed[1],
            email: Faker::Internet.email,
            username: detailUsed[2],
            password: "Password12345", # issue each user the same password
            password_confirmation: "Password12345",
            isAdmin: false,
            phoneNumber: Faker::Number.number(digits: 9),
            DOB: Faker::Date.birthday(min_age: 18, max_age: 90),
            address: Faker::Address.full_address[0..150]
        )
    end
  end

  def generateAccounts(amount, newUsers, transactionAmount)
    @limit = 0
    if !Account.first.nil?
        @limit = Account.last.id.to_i + 1
    end
    @userLimit = 0
    if !User.first.nil?
        @userLimit = User.last.id.to_i + 1
    end
    account_ids = Array.new()
    (@limit .. (@limit + amount-1)).each do |id|
          accountid = Faker::Number.between(from: 10000000, to: 90000000)
          account_ids << accountid.to_i
        Account.create!(
            id: accountid,
            user_id: User.find(rand((@userLimit - newUsers) .. (@userLimit -1))).id,
            sortCode: Faker::Number.number(digits: 6),
            balance: Faker::Number.number(digits: 7),
            currency: %w[USD GBP EUR].sample
        )
    end
    generateTransactions(transactionAmount,account_ids)
  end

  def generateTransactions(amount, account_ids)
    @limit = 0
    if !Transaction.first.nil?
        @limit = Transaction.last.id.to_i + 1
    end
    @accountLimit = 0
    if !Account.first.nil?
        @accountLimit = Account.last.id.to_i + 1
    end
    (@limit .. @limit + amount-1).each do |id|
        Transaction.create!(
          id: id,
          sender_id: account_ids.sample,
          # money to random account that doesnt exist
          receiver_id: Faker::Number.number(digits: 8),
          amount: Faker::Number.between(from: 10, to: 99999),
          created_at: Faker::Time.between(from: DateTime.now - 365, to: DateTime.now, format: :default)
        )
      end

      @limit = Transaction.last.id.to_i + 1

        (@limit .. @limit + amount -1).each do |id|
        Transaction.create!(
          id: id,
          # money from random account that doesnt exist
          sender_id: Faker::Number.number(digits: 8),
          receiver_id: account_ids.sample,
          amount: Faker::Number.between(from: 10, to: 99999),
          created_at: Faker::Time.between(from: DateTime.now - 365, to: DateTime.now, format: :default)

        )
      end
  end

# for generating transaction data for a single user, # of transaction specificed
# is doubled, once for sent, once for recieve.
  def userGenerateTransaction(userID, amount)

    User.find(userID).accounts.each do |account|
      @limit = Transaction.last.id.to_i + 1
        (@limit .. @limit + amount-1).each do |id|
          Transaction.create!(
            id: id,
            sender_id: account.id.to_i,
            receiver_id: Faker::Number.number(digits: 8),
            amount: Faker::Number.between(from: 10, to: 99999),
            created_at: Faker::Time.between(from: DateTime.now - 700, to: DateTime.now, format: :default)
          )
        end

        @limit = Transaction.last.id.to_i + 1
        (@limit .. @limit + amount-1).each do |id|
          Transaction.create!(
            id: id,
            sender_id: Faker::Number.number(digits: 8),
            receiver_id: account.id.to_i,
            amount: Faker::Number.between(from: 10, to: 99999),
            created_at: Faker::Time.between(from: DateTime.now - 700, to: DateTime.now, format: :default)
          )
        end

    end

  end

end
