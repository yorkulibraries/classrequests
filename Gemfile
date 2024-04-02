source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version').strip

###############
#### CORE #####
###############
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
# gem 'rails', '~> 6.1.4'
gem 'rails', '7.0.8'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Reduces boot times through caching; required in config/boot.rb
# gem 'bootsnap', '>= 1.4.4', require: false
gem 'bootsnap', '>= 1.9.2', require: false

###############
## DATABASES ##
###############
gem 'mysql2', '~> 0.5.3'
# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

############################################
## CSS AND JavaScript + TOOLS and HELPERS ##
############################################

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

## Exporting to Excel
# gem 'axlsx', git: 'https://github.com/randym/axlsx.git'
# gem 'axlsx_rails', '0.5.1'
gem 'caxlsx', '~> 3.1.0'
gem 'caxlsx_rails', '~> 0.6.2'

## Simple Calendar to display classes
gem 'simple_calendar', '~> 2.3.0'
# Jquery-plugin chosen for rails for drop downs and multiple selects

gem 'invisible_captcha', '~> 0.12.0' # For Public forms.
# gem 'jquery-rails', '~> 4.3.3'
# gem 'jquery-ui-rails', '6.0.1' # For Jquery Effects.
gem 'jquery-timepicker-rails'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'simple_form', '~> 5.1.0'
gem 'font-awesome-sass', '~> 5.15.1'
# gem 'chosen-rails', '~> 1.9.0'
gem 'devise', '~> 4.8', '>= 4.8.0'
gem 'devise-bootstrapped', github: 'king601/devise-bootstrapped', branch: 'bootstrap5'
# gem 'gravatar_image_tag', github: 'mdeering/gravatar_image_tag'
gem 'gravatar_image_tag', github: 'Envek/gravatar_image_tag', branch: 'fix/deprecation-warnings'
# gem 'mini_magick', '~> 4.11', '>= 4.11.0'
## For paging of viewing data.
gem 'kaminari', '~> 1.2' #, :git => 'https://github.com/kaminari/kaminari'
gem 'bootstrap5-kaminari-views', '~> 0.0.1'

# Pretty dump of inspect
gem 'awesome_print', require: 'ap'

# For Enum
# gem 'enumerize', '~> 2.4'
gem 'enumerize', '~> 2.5'


# For application settings
gem 'rails-settings-cached', '~> 2.8'

# For Bootstrap Like emails  (installs htmlbeautifier, css_parser, premailer, bootstrap-email)
# Ref: https://bootstrapemail.com/docs/usage
# Online Editor: https://app.bootstrapemail.com/editor?version=1
gem 'bootstrap-email', '~> 1.4' #bump to 1.4 after init testing

## Action Text Attachements and active storage. Note: UBUNTU RUN: sudo apt-get install imagemagick on server
gem 'image_processing', '~> 1.2'

## Searching and Sorting
gem 'ransack', '~> 4.1'

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.39'
  gem 'selenium-webdriver', '~> 4.15'
  # Easy installation and use of web drivers to run system tests with browsers
  # gem 'webdrivers', '~> 4.6.0'
end

group :development, :test do

  #i18n-tasks helps you find and manage missing and unused translations.
  # bundle exec i18n-tasks, i18n-tasks health, i18n-tasks add-missing, GET HELP: i18n-tasks add-missing --help
  gem 'i18n-tasks', '~> 0.9'

  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails', '6.2.0'
  gem 'faker', '~> 2.18.0'
  # gem 'populator', git: 'https://github.com/norikt/populator.git'
  gem 'populator', git: 'https://github.com/ShareWis/populator'
  gem 'rubocop', '~> 1.18', require: false
  gem 'shoulda', '~> 4.0'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'shoulda-context', '~> 2.0.0'
  gem 'database_cleaner-active_record'
  gem 'rails-controller-testing'

  #had to add rspec for enumerize/integrations/rspec call for "should enumerize(xyz)" tests
  gem "rspec-rails" 
end
