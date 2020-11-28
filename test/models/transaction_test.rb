require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  
  test 'sender_id and receiver_id should be different' do
    transaction = Transaction.new(:sender_id => 1, :receiver_id => 1, :amount => 100)
    assert_not transaction.valid?
  end

  test 'transaction amount cannot be 0' do
    transaction = Transaction.new(:sender_id => 1, :receiver_id => 2, :amount => 0)
    assert_not transaction.valid?
  end

  test 'transaction amount cannot be smaller than 0' do
    transaction = Transaction.new(:sender_id => 1, :receiver_id => 2, :amount => -1)
    assert_not transaction.valid?
  end

  test 'transaction amount cannot be a really big number' do
    transaction = Transaction.new(:sender_id => 1, :receiver_id => 2, :amount => 10000000000000000000000)
    assert transaction.valid?
  end

  test 'valid transaction' do
    transaction = Transaction.new(:sender_id => 1, :receiver_id => 2, :amount => 2500)
    assert transaction.valid?
  end

end
