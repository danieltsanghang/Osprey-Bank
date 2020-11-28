ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!
class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Helper function to test if the user is logged in for testing purposes
  def is_logged_in?
    !session[:user_id].nil?
  end

end

# This class was developed with the help of the LGT
class ActionDispatch::IntegrationTest

  # Helper function to login into the website as a user for testing purposes
  def login_as_user(user, password)
    post login_url, params: { session: { username: user.username, password: password} }
  end

end
