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

  # Helper function to convert an amount from one currency to another
  def convert(amount, currency_from, currency_to)
    return Money.new(amount, currency_from).exchange_to(currency_to).fractional
  end

end

# This class was developed with the help of the LGT
class ActionDispatch::IntegrationTest

  # Helper function to login into the website as a user for testing purposes
  def login_as_user(user, password)
    post login_url, params: { session: { username: user.username, password: password} }
  end

  # Helper function to logout of website for testing purposes
  def logout
    session.delete(:user_id)
  end

end
