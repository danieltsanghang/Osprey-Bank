require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest

  test "should not show accounts page without login" do
    #perform GET without login
    get accounts_url
    assert_response :redirect
  end

  test "should not show individual account page without login" do
    #get random account and try to access without logging user in
    account = accounts(:account_1)
    get account_url(account.id)
    assert_response :redirect
  end

  test "should not allow access to external accounts while user logged in" do
    #log user and try and access external account
    user = users(:user)
    login_as_user(user, "password1")
    account = accounts(:account_2) #an external account
    get account_url(account.id)
    assert_response :missing
  end

  test "should open accounts page with login" do
    #log user in and open accounts page
    user = users(:user)
    login_as_user(user, "password1")
    get accounts_url
    assert_response :success
  end

  test "should show individual account page with login" do
    #log user in and show their first account
    user = users(:user)
    login_as_user(user, "password1")
    account = user.accounts[0]
    get account_url(account.id)
    assert_response :success
  end



end
