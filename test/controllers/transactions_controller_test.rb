require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    # Get 2 users, one will be the sender and one will be the receiver of the transaction
    @sender = users(:user).accounts[0]
    @receiver = users(:user_2).accounts[0]

    # Login as the sender
    login_as_user(users(:user), "password1")

    # Get the each user's balance before the transaction
    @sender_balance_before = @sender.balance
    @receiver_balance_before = @receiver.balance
  end

  def teardown
    logout
  end

  test "should show transaction" do
    # Get user from fixtures and login
    user = users(:user)
    login_as_user(user, "password1")
    assert_response :redirect # User redirected after authenticated

    # Show transaction from fixture
    get transaction_url(transactions(:transaction_one))
    assert_response :success
  end

  test 'should open transactions page after login' do
    logout
    # Get user from fixtures and login
    user = users(:user)
    login_as_user(user, "password1")
    assert_response :redirect # User redirected after authenticated

    get transactions_url
    assert_response :success
  end

  test 'should open account transactions page after login' do
    logout
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
    logout
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

  test 'should make transactions for valid users and valid amount' do
    # Perform the transaction using a post request with the correct parameters
    sender = users(:user_2).accounts[1]
    sender_balance_before = sender.balance
    post transactions_url, params: { transaction: { sender_id: sender.id, receiver_id: @receiver.id, amount: 10} }

    assert User.find(2).accounts[1].balance == sender_balance_before - (10 * 100) 
    assert User.find(2).accounts[0].balance == @receiver_balance_before +  (10 * 100) 
  end

  test 'should make transactions for valid users and valid amount (amount = balance)' do
    # Perform the transaction using a post request with the correct parameters
    sender = users(:user_2).accounts[1]
    sender_balance_before = sender.balance
    post transactions_url, params: { transaction: { sender_id: sender.id, receiver_id: @receiver.id, amount: (sender_balance_before/100) } }
  
    puts User.find(2).accounts[1].balance
    puts User.find(2).accounts[0].balance

    assert User.find(2).accounts[1].balance == 0
    assert User.find(2).accounts[0].balance == (@receiver_balance_before + sender_balance_before)
  end

  test 'should redirect to new_transaction_url if transaction fails' do
    # Perform the transaction using a post request with the correct parameters and invalid amount in order to fail the transaction
    post transactions_url, params: { transaction: { sender_id: @sender.id, receiver_id: @receiver.id, amount: 0} }

    assert_redirected_to new_transaction_url # if the transaction fails, the user should be redirected to the transactions new page (the same page)
    follow_redirect! # Follow redirect
    assert_template 'transactions/new' # the template displayed is the transactions new page of the user
    assert session[:user_id] == @sender.user.id # Make sure it's the correct user
  end

  test 'should not make transactions for valid users and invalid amount (amount = 0)' do
    # Perform the transaction using a post request with the correct parameters
    post transactions_url, params: { transaction: { sender_id: @sender.id, receiver_id: @receiver.id, amount: 0} }

    follow_redirect! # Follow redirect

    # Assert that the sender's and receiver's balance is not changed
    assert User.find(1).accounts[0].balance == @sender_balance_before
    assert User.find(2).accounts[0].balance == @receiver_balance_before
  end

  test 'should not make transactions for valid users and invalid amount (amount = -10)' do
    # Perform the transaction using a post request with the correct parameters
    post transactions_url, params: { transaction: { sender_id: @sender.id, receiver_id: @receiver.id, amount: -10} }

    follow_redirect! # Follow redirect

    # Assert that the sender's and receiver's balance is not changed
    assert User.find(1).accounts[0].balance == @sender_balance_before
    assert User.find(2).accounts[0].balance == @receiver_balance_before
  end

  test 'should not make transactions for valid users and invalid amount (amount > balance)' do
    # Perform the transaction using a post request with the correct parameters
    post transactions_url, params: { transaction: { sender_id: @sender.id, receiver_id: @receiver.id, amount: @sender.balance+1} }

    follow_redirect! # Follow redirect

    # Assert that the sender's and receiver's balance is not changed
    assert User.find(1).accounts[0].balance == @sender_balance_before
    assert User.find(2).accounts[0].balance == @receiver_balance_before
  end

end
