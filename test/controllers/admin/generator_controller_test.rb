require 'test_helper'

class Admin::GeneratorControllerTest < ActionDispatch::IntegrationTest
    def setup
        #get admin user
        @admin = users(:admin)

        #login as admin
        login_as_user(users(:admin), "password1")
    end

    def teardown
        logout
    end

    
end
