class AdminsController < ApplicationController
    before_action :redirect_to_login_if_not_admin
    def show

    end

end