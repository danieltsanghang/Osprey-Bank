require 'test_helper'
require 'application_helper'
class ApplicationHelperTest < ActionDispatch::IntegrationTest
include ApplicationHelper

test "transaction currency should be determined by sender" do
  user = users(:user)
  login_as_user(user, "password1")
  assert_response :redirect # User redirected after authenticated
  transaction_one = Transaction.find_by(:sender_id => 1)
  assert_equal "GBP", findCurrency(transaction_one.sender_id,transaction_one.receiver_id,"sent")
end

test "fake transaction currency should be USD" do
transaction = Transaction.find_by(:sender_id => 2123)
assert_equal "USD", findCurrency(transaction.sender_id,transaction.receiver_id,"sent")
assert_equal "USD", findCurrency(transaction.sender_id,transaction.receiver_id,"recieve")
end


end
