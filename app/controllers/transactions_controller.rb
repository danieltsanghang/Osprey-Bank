class TransactionsController < ApplicationController

    before_action :redirect_to_login_if_not_logged_in
    
end
