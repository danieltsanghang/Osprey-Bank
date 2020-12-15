require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get maintenance page" do
    get home_maintenance_url
    assert_response :success
  end


end
