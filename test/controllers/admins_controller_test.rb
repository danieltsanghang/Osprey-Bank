require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest

    test 'admin should be able to open the admin dashboard page' do
        # Login as the admin
        login_as_user(users(:admin), "password1")

        get admins_url

        assert_response :success
    end

    test 'regular users should be able to open the admin dashboard page' do
        # Login as a user
        login_as_user(users(:user), "password1")

        get admins_url

        assert_redirected_to login_url
    end

    test 'non logged in users should be able to open the admin dashboard page' do
        # Access the admins url without logging in
        get admins_url

        assert_redirected_to login_url
    end

end