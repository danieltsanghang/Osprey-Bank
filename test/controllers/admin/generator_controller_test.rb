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

    test 'admin can generate fake data using valid inputs' do
        post admin_generator_index_url, params: {generator: {users: 1, accounts: 2, transactions: 3}}

        assert_redirected_to admin_users_url
    end

    test 'admin cannot generate fake data with no users input' do
      post admin_generator_index_url, params: {generator: {users: "", accounts: 2, transactions: 3}}

      #should redirect to same form page if there is an error
      assert_generates "admin/generator/new", controller: "admin/generator", action: "new"
    end

    test 'admin cannot generate fake data with no accounts input' do
      post admin_generator_index_url, params: {generator: {users: 1, accounts: "", transactions: 3}}

      #should redirect to same form page if there is an error
      assert_generates "admin/generator/new", controller: "admin/generator", action: "new"
    end

end
