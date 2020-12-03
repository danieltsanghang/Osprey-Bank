module ApplicationHelper
  def redirect_to_404
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404 # Render 404 page
  end
  def findCurrency(sender,reciever,direction)

    if(Account.find_by(:id => sender).nil?)
      return "USD"
    else
      return Account.find_by(:id => sender).currency
    end

  end

  def convert(money,currency)
      return money.exchange_to(haveCurrency(currency)).format
    end

def haveCurrency(currency)
  if(currency.nil? && params.has_key?(:account_id))
    return Account.find_by(params[:account_id])
  end
  if(currency.nil? && !params.has_key?(:account_id))
    return "USD"
  end
  return currency
end

end
