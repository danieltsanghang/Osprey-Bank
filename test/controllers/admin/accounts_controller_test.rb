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

  #------------------------------
  #Tests for listing all accounts
  #------------------------------
  test 'admin should be able to view all accounts via index action' do
      get admin_accounts_url
      assert_response :success
  end

  test 'user should not be able to access accounts in admin namespace' do
      #logout and clear cache
      logout
      Rails.cache.clear

      #login as non-admin user
      login_as_user(users(:user), "password1")

      #get index action for accounts
      get admin_accounts_url

      #should be redirected to login page
      assert_redirected_to login_url
  end

  #-------------------------------------
  #Tests for viewing individual accounts
  #-------------------------------------
  test 'admin should be able to view single account via show action' do
      #view specific account
      get admin_account_url(@account)

      #should show all accounts
      assert_response :success
  end

  #---------------------
  #Tests for editing accounts
  #---------------------
  test 'admin can edit account balance with valid amount' do
      #edit account with new balance
      patch admin_account_url(@account), params: {:account => {:balance => 1000}}

      #reload account object
      @account.reload

      #assert new balance (it is time 100 because of Money objects)
      assert @account.balance == 100000
  end

  test 'admin cannot edit account balance with invalid amount' do
      #edit account with new balance
      patch admin_account_url(@account), params: {:account => {:balance => 1000}}

      #reload account object
      @account.reload

      #user should be redirected back to show account page
      assert_not(@account.balance == 1000)
  end

  test 'admin can edit account currency with valid currency' do
      patch admin_account_url(@account), params: {:account => {:currency => "EUR"}}

      #reload account
      @account.reload

      #new currency should be "EUR"
      assert @account.currency == "EUR"
  end

  test 'admin cannot edit account currency with invalid currency' do
      #edit account with unsupported currency
      patch admin_account_url(@account), params: {:account => {:currency => "YEN"}}

      #reload account object
      @account.reload

      #should redirect to show account page
      assert_not(@account.currency == "YEN")
  end

  test 'admin can edit account sort code with valid sort code' do
      patch admin_account_url(@account), params: {:account => {:sortCode => 111111}}

      #reload account
      @account.reload

      #new sort code should be 111111
      assert @account.sortCode == 111111
  end

  test 'admin cannot edit account sort code with invalid sort code' do
      patch admin_account_url(@account), params: {:account => {:sortCode => 1}}

      #reload account object
      @account.reload

      #should redirect to show account page
      assert_not(@account.sortCode == 1)
  end


  test 'admin can edit account user id with user id that exists' do
      patch admin_account_url(@account), params: {:account => {:user_id => 2}}

      #reload account
      @account.reload

      #new user_id should be 2
      assert @account.user_id == 2
  end

  test 'admin cannot edit account user id with user id that does not exist' do
    patch admin_account_url(@account), params: {:account => {:user_id => 100}}

    #reload account object
    @account.reload

    #should redirect to account show
    assert_not(@account.user_id == 100)
  end

  #---------------------------
  #Tests for deleting accounts
  #---------------------------

  test 'admin should be able to delete accounts' do
      #delete account
      delete admin_account_url(@account)

      #should redirect to list of accounts
      assert_redirected_to admin_accounts_url
  end

  #---------------------------
  #Tests for creating accounts
  #---------------------------

  test 'admin can create account with all valid details' do
      post admin_accounts_url, params: {:account => {:user_id=> 1, :sortCode => 222222,
        :balance => 216500.0, :currency=> "GBP"}}

      #user should be created
      assert Account.where(user_id: 1).exists?
  end

  test 'admin cannot create account with user id that does not exist' do
    post admin_accounts_url, params: {:account => {:user_id=> 100, :sortCode => 222222,
      :balance => 216500.0, :currency=> "GBP"}}

    #user should not be created
    assert_not Account.where(user_id: 100).exists?
  end


  test 'admin cannot create account with invalid sort code' do
    post admin_accounts_url, params: {:account => {:user_id=> 1, :sortCode => 2,
      :balance => 216500.0, :currency=> "GBP"}}

    #user should not be created
    assert_not Account.where(user_id: 1, sortCode: 2).exists?
  end

  test 'admin cannot create account with invalid currency' do
    post admin_accounts_url, params: {:account => {:user_id=> 1, :sortCode => 222222,
      :balance => 216500.0, :currency=> "YEN"}}

    #user should not be created
    assert_not Account.where(user_id: 1, currency: "YEN").exists?
  end

  #-------------------------------
  #Tests for account id
  #-------------------------------

  test 'admin can manually set a valid account id' do
    post admin_accounts_url, params: {:account => {:id => 10000000, :user_id=> 1, :sortCode => 222222,
      :balance => 216500.0, :currency=> "GBP"}}

    #user should be created
    assert Account.exists?(10000000)
  end

  test 'admin can manually set a valid account id of length 7' do
    post admin_accounts_url, params: {:account => {:id => 1000000, :user_id=> 1, :sortCode => 222222,
      :balance => 216500.0, :currency=> "GBP"}}

    #user should be created
    assert Account.exists?(1000000)
  end

  test 'admin can manually set a valid account id of length 9' do
    post admin_accounts_url, params: {:account => {:id => 100000000, :user_id=> 1, :sortCode => 222222,
      :balance => 216500.0, :currency=> "GBP"}}

    #user should be created
    assert Account.exists?(100000000)
  end

  test 'admin cannot manually set an invalid account with an id of length < 7' do
    post admin_accounts_url, params: {:account => {:id => 111111, :user_id=> 1, :sortCode => 222222,
      :balance => 216500.0, :currency=> "GBP"}}

    #user should be created
    assert_not Account.exists?(111111)
  end

  test 'admin cannot manually set an invalid account with an id of length > 9' do
    post admin_accounts_url, params: {:account => {:id => 2222222222, :user_id=> 1, :sortCode => 222222,
      :balance => 216500.0, :currency=> "GBP"}}

    #user should be created
    assert_not Account.exists?(2222222222)
  end
  
  #----------------------------------------------
  #Tests for searching and filtering transactions
  #----------------------------------------------
  
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
