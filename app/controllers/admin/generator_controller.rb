class Admin::GeneratorController < ApplicationController
      def new

      end
    def create
        redirect_to(admin_users_url)
    end

end
