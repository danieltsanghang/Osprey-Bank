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

end
