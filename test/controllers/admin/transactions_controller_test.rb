require 'test_helper'

class Admin::TransactionsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    # Get 2 users, one will be the sender and one will be the receiver of the transaction
    @sender = users(:user).accounts[0]
    @receiver = users(:user_2).accounts[0]

    # Get admin and login as admin
    @admin = users(:admin)

    # Login as the admin
    login_as_user(users(:admin), "password1")

    # Get the each user's balance before the transaction
    @sender_balance_before = @sender.balance
    @receiver_balance_before = @receiver.balance
  end

  def teardown
    logout
  end

  test 'admin should be able to create transactions between accounts in different currencies' do
    # This test tests if the admin can create transactions and if the transactions are valid, meaning:
    # if an account with USD sends money to an account with GBP, does it do the correct conversions between
    # each account
    post admin_transactions_url, params: { transaction: { sender_id: @sender.id, receiver_id: @receiver.id, amount: 10 } }

    # Reload objects with the uodated attributes
    @sender.reload
    @receiver.reload

    # Assert currency conversions are valid 
    assert @sender.balance == @sender_balance_before - (10 * 100)
    assert @receiver.balance == @receiver_balance_before + convert(10 * 100, 'GBP', 'USD')
  end

  test 'admin should be able to create transactions between accounts in the same currency' do
    sender = users(:user_2).accounts[1]
    sender_balance_before = sender.balance
    post admin_transactions_url, params: { transaction: { sender_id: sender.id, receiver_id: @receiver.id, amount: 10 } }

    # Reload objects with the uodated attributes
    sender.reload
    @receiver.reload

    # Assert new balance is correct with no currency conversion
    assert sender.balance == sender_balance_before - (10 * 100)
    assert @receiver.balance == @receiver_balance_before + (10 * 100)
  end


  test 'admin should be not able to create invalid transactions' do
    sender = users(:user_2).accounts[1]
    sender_balance_before = sender.balance
    post admin_transactions_url, params: { transaction: { sender_id: sender.id, receiver_id: @receiver.id, amount: sender.balance } }

    # Reload objects with the uodated attributes
    sender.reload
    @receiver.reload

    # Assert new balance is same as before
    assert sender.balance == sender_balance_before 
    assert @receiver.balance == @receiver_balance_before
  end

  test 'admin should be able to delete transactions' do
    # Get transaction and delete it
    transaction = transactions(:transaction_one)
    delete admin_transaction_url(transaction)

    assert_redirected_to admin_transactions_url
  end

  test 'user balance should update after admin deletes transaction' do
    # Get transaction details and delete it
    transaction = transactions(:transaction_one)
    sender = transaction.sender
    sender_balance_before = sender.balance
    transaction_amount = transaction.amount

    delete admin_transaction_url(transaction)

    # Reload the sender
    sender.reload

    # Make sure the balance was updated
    assert sender.balance - (transaction_amount) == sender_balance_before
  end

  test 'admin should be able to edit transaction amount' do
    # Get transaction
    transaction = transactions(:transaction_one)

    # Edit the amount
    patch admin_transaction_url(transaction), params: { :transaction => { :amount => 5 }}

    # Reload the object
    transaction.reload

    # Assert the new amount (it is times 100 because of the Money objects)
    assert transaction.amount == 500
  end

  test 'admin should be able to edit transaction sender' do
    # Get transaction
    transaction = transactions(:transaction_one)

    # Edit the sender_id
    patch admin_transaction_url(transaction), params: { :transaction => { :sender_id => 42 }}

    # Reload the transaction
    transaction.reload

    # Assert the new sender id
    assert transaction.sender_id == 42
  end

  test 'admin should be able to edit transaction receiver' do
    # Get transaction
    transaction = transactions(:transaction_one)

    # Edit the transaction receiver_id
    patch admin_transaction_url(transaction), params: { :transaction => { :receiver_id => 27 }}

    # Reload the transaction
    transaction.reload

    # Assert the new receiver id
    assert transaction.receiver_id == 27
  end

  test 'sender balance should update correctly after admin edits the transaction' do
    # Get transaction
    transaction = transactions(:transaction_one)

    # Get neccesary details from transaction before updating it
    transaction_old_amount = transaction.amount
    sender = transaction.sender
    sender_balance_before = transaction.sender.balance

    # Perform the edit
    patch admin_transaction_url(transaction), params: { :transaction => { :amount => 5 }}

    # Reload the objects
    transaction.reload
    sender.reload

    # Assert correct balance change
    assert (sender_balance_before + transaction_old_amount) - 500 == sender.balance
  end

  test 'receiver balance should update correctly after admin edits the transaction' do
    # Get transaction
    transaction = transactions(:transaction_six)

    # Get neccesary details from transaction before updating it
    transaction_old_amount = transaction.amount
    receiver = transaction.receiver
    receiver_balance_before = transaction.receiver.balance

    # Perform the edit
    patch admin_transaction_url(transaction), params: { :transaction => { :amount => 5 }}

    # Reload the objects
    transaction.reload
    receiver.reload

    # Assert correct balance change
    assert (receiver_balance_before - transaction_old_amount) + 500 == receiver.balance
  end

  test 'admin should be able to access show for transactions' do
    transaction = transactions(:transaction_six)
    get admin_transaction_url(transaction) # Get the show action for one of the transactions
    assert_response :success # Should be allowed
  end

  test 'admin should be able to access index for transactions' do
    get admin_transactions_url # Get the index action
    assert_response :success # Should be allowed
  end

  test 'user should not be able to access admin namespace' do
    # Logout and clear cache
    logout
    Rails.cache.clear

    # Login as regular user (NOT admin)
    login_as_user(users(:user), "password1")

    get admin_transactions_url # Get the index action for transactions in the admin namespace

    # Should be redirected to login as they do not have access to admin side
    assert_redirected_to login_url
  end

  test 'search through all transactions correctly' do
    # Filter through transactions for a specific key (receiver_id in this case), result should only be a list of length 1
    get admin_transactions_path, params: { :search_transaction => 234234 }
    assert assigns(:transactions).size == 1 
  end

  test 'search through all transactions with a value that does not exists correctly' do
    # Filter through transactions for a specific value that does not exist, result size should be 0
    get admin_transactions_path, params: { :search_transaction => "thisdoesnotexist" }
    assert assigns(:transactions).size == 0
  end

  test 'search through all transactions with empty string should return all transactions' do
    # Filter through transactions with empty string, all results should be returned (number of transaction fixtures = 6)
    get admin_transactions_path, params: { :search_transaction => "" }
    assert assigns(:transactions).size == 6
  end

  test 'sort through transactions should sort correctly' do
    # Sort by amount in a descending order, this means the first result should have the greatest amount from the fixtures, which is 5000000000
    get admin_transactions_path, params: { :sort => "amount", :direction => "desc" }
    assert assigns(:transactions)[0].amount == 5000000000
  end

end
