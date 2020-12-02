module AccountsHelper
  def convert(money,currency)
    return money.exchange_to(currency).format
  end
end
