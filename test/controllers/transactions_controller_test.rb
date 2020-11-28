require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test 'should not open transactions page without login' do
    get transactions_url
    assert_response :redirect
  end

  test 'should open transactions page after login' do
    # Get user from fixtures and login
    user = users(:user)
    login_as_user(user, "password1")
    assert_response :redirect # User redirected after authenticated

    get transactions_url
    assert_response :success
  end

  test 'should open account transactions page after login' do
    # Get user from fixtures and login
    user = users(:user_2)
    login_as_user(user, "password2")
    assert_response :redirect # User redirected after authenticated

    # Get one of the accounts associated with a user, and view it's transactions
    account = user.accounts[0]
    get account_transactions_url(account)
    assert_response :success
  end

  test 'should not open account transactions page after login for another user' do
    # Get user from fixtures and login
    user = users(:user_2)
    not_user = users(:user)
    login_as_user(user, "password2")
    assert_response :redirect # User redirected after authenticated

    # Get one of the accounts associated with a user, and view it's transactions
    account = not_user.accounts[0]
    get account_transactions_url(account)
    assert_response 404
  end

end
