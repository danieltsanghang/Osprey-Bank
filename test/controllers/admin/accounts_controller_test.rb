require 'test_helper'

class Admin::AccountsControllerTest < ActionDispatch::IntegrationTest

  def setup
    #Get account
    @account = accounts(:account_1)
    #Get admin
    @admin = users(:admin)

    #login as admin
    login_as_user(users(:admin), "password1")
end

def teardown
    logout
end

  test 'search through all accounts correctly' do
    # Filter through accounts for a specific key (sortCode in this case), result should only be a list of length 1 based on the test fixtures
    get admin_accounts_path, params: { :search_account => 654321 }
    assert assigns(:accounts).size == 1 
  end

  test 'search through all accounts with a value that does not exists correctly' do
    # Filter through accounts for a specific value that does not exist, result size should be 0
    get admin_accounts_path, params: { :search_account => "thisdoesnotexist" }
    assert assigns(:accounts).size == 0
  end

  test 'search through all accounts with empty string should return all accounts' do
    # Filter through accounts with empty string, all search_account should be returned (number of account fixtures = 3)
    get admin_accounts_path, params: { :search_account => "" }
    assert assigns(:accounts).size == 3
  end

  test 'sort through accounts should sort correctly' do
    # Sort by balance in a descending order, this means the first result should have the greatest amount from the fixtures, which is 10000
    get admin_accounts_path, params: { :sort => "balance", :direction => "desc" }
    assert assigns(:accounts)[0].balance == 10000
  end
end
