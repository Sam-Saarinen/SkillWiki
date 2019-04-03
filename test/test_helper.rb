ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  include Devise::TestHelpers
  # https://github.com/plataformatec/devise/blob/1094ba65aac1d37713f2cba71f9edad76b5ca274/lib/devise/test_helpers.rb

  sign_in @user
  sign_out @user

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # def login_user
  #   @request.env["devise.mapping"] = Devise.mappings[:user_1]
  #   user = FactoryGirl.create(:user_1)
  #   sign_in user
  # end
end
