ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require 'capybara/rails'
# require 'capybara/rails'
# require 'capybara/minitest'
require 'factory_bot'
require 'shoulda'
# require 'enumerize'

  


class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)
  # parallelize(workers: 3)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  include FactoryBot::Syntax::Methods
  include Devise::Test::IntegrationHelpers
  include Capybara::DSL

  # include Devise::TestHelpers
  include Shoulda::Matchers::ActiveRecord
  extend Shoulda::Matchers::ActiveRecord
  include Shoulda::Matchers::ActiveModel
  extend Shoulda::Matchers::ActiveModel

  require 'enumerize/integrations/rspec'
  extend Enumerize::Integrations::RSpec

  # Add more helper methods to be used by all tests here...
end
