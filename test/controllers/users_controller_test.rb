require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "should show user" do
    user = users(:user)
    get user_url(user)
    assert_response:success
  end
end
