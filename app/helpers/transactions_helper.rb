module TransactionsHelper
  def findCurrency(sender,reciever,direction)
    if(direction == "sent" && !Account.find(sender).nil?)
      return Account.find(sender).currency
    else if (direction == "recieve" && !Account.find(reciever).nil?)
      return Account.find(reciever).currency
    else
      return "USD"
    end
    end
  end
  def convert(money,currency)
    return money.exchange_to(currency).format
  end
end
