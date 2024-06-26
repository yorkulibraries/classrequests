require_relative "boot"

require "rails/all"
# require_relative "../app/models/setting"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Libstar
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.libstar_version = 2.0
    # config.load_defaults 6.1
    config.load_defaults 7.0
    # config.hosts << "127.0.0.1"
    # config.hosts << "classrequests.me.ca"
    # config.hosts << "classrequests.library.yorku.ca"
    # config.hosts << "classrequests-dev.library.yorku.ca"

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.orm             :active_record
      g.template_engine :erb
      g.test_framework  :shoulda, fixture: false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false

      # Add a fallback!
      g.fallbacks[:shoulda] = :test_unit
    end
    config.i18n.default_locale = :en
    config.i18n.fallbacks = [:en]
    config.i18n.available_locales = [:en, 'fr-ca']
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.assets.paths << Rails.root.join('app', 'assets', 'images', 'backgrounds')

    # set delivery method to :smtp, :sendmail or :test
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = { address: ENV['MAILER_SMTP_HOST'], port: ENV['MAILER_SMTP_PORT'] }
    config.action_mailer.default_url_options = { host: ENV['MAILER_DEFAULT_URL'] }
    config.action_mailer.default_options = { from: ENV['MAILER_DEFAULT_FROM'] }

  end
end
