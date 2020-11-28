require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test 'should not open transactions page without login' do
    get transactions_url
    assert_response :redirect
  end

end
