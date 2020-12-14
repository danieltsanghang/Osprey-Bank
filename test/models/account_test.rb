require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "sort code has 6 digits" do
    account = Account.new(:user_id => 1, :sortCode => 123456, :currency => "USD")
    assert account.valid?
  end

  test "sort code does not have 6 digits" do
    account = Account.new(:user_id => 1, :sortCode => 12345, :currency => "USD")
    assert_not account.valid?
  end

  test "currency is valid" do
    account = Account.new(:user_id => 1, :sortCode => 123456, :currency => "USD")
    assert account.valid?
  end

  test "currency is invalid" do
    account = Account.new(:user_id => 1, :sortCode => 123456, :currency => "LOL")
    assert_not account.valid?
  end

  test 'default balance is 0' do
    account = Account.new(:user_id => 1, :sortCode => 123456, :currency => "USD")
    account.save
    assert account.balance == 0
  end
  
end
