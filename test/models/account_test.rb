require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "sort code has 6 digits" do
    account = Account.new(:id => 102345678, :user_id => 1, :sortCode => 123456, :currency => "USD")
    assert account.valid?
  end

  test "sort code does not have 6 digits" do
    account = Account.new(:id => 102345678, :user_id => 1, :sortCode => 12345, :currency => "USD")
    assert_not account.valid?
  end

  test "currency is valid" do
    account = Account.new(:id => 102345678, :user_id => 1, :sortCode => 123456, :currency => "USD")
    assert account.valid?
  end

  test "currency is invalid" do
    account = Account.new(:id => 102345678, :user_id => 1, :sortCode => 123456, :currency => "LOL")
    assert_not account.valid?
  end

  test "default balance is 0" do
    account = Account.new(:id => 102345678, :user_id => 1, :sortCode => 123456, :currency => "USD")
    account.save
    assert account.balance == 0
  end

  test "id can be set manually if valid" do
    account = Account.new(:id => 10234589, :user_id => 1, :sortCode => 123456, :currency => "USD")
    account.save
    assert Account.exists?(10234589)
  end

  test "id is invalid if less than 7 digits" do
    account = Account.new(:id => 123456, :user_id => 1, :sortCode => 123456, :currency => "USD")
    account.save
    assert_not Account.exists?(123456)
  end

  test "id is invalid if more than 9 digits" do
    account = Account.new(:id => 1234567890, :user_id => 1, :sortCode => 123456, :currency => "USD")
    account.save
    assert_not Account.exists?(1234567890)
  end
  
end
