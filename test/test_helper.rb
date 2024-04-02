

# frozen_string_literal: false

# some of the comments are in UTF-8
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'minitest/unit'
require 'database_cleaner/active_record'
require 'capybara/rails'
require 'capybara/minitest'
require 'factory_bot'
require 'shoulda'
require 'rails-controller-testing'
Rails::Controller::Testing.install

DatabaseCleaner.url_allowlist = [
  %r{.*test.*}
]
DatabaseCleaner.strategy = :truncation

Capybara.server_host = '0.0.0.0'
Capybara.app_host = "http://#{Socket.gethostname}:#{Capybara.server_port}"

include ActionDispatch::TestProcess

module ActiveSupport
  class TestCase
    
    include Devise::Test::IntegrationHelpers

    # include Devise::TestHelpers
    include Shoulda::Matchers::ActiveRecord
    extend Shoulda::Matchers::ActiveRecord
    include Shoulda::Matchers::ActiveModel
    extend Shoulda::Matchers::ActiveModel

    require 'enumerize/integrations/rspec'
    extend Enumerize::Integrations::RSpec


    # Add more helper methods to be used by all tests here...
    include FactoryBot::Syntax::Methods
    include Warden::Test::Helpers
    Warden.test_mode!

    # Make the Capybara DSL available in all integration tests
    include Capybara::DSL
    # Make `assert_*` methods behave like Minitest assertions
    include Capybara::Minitest::Assertions

    setup do
      DatabaseCleaner.start
    end

    teardown do
      #Capybara.reset_sessions!
      #Capybara.use_default_driver
      DatabaseCleaner.clean
    end
  end
end

