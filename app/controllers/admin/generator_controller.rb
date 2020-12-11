class Admin::GeneratorController < ApplicationController
    def create

        redirect_to(admin_users_url)
    end

    def new
        
    end
end
