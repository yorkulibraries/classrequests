require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  include Warden::Test::Helpers
  Warden.test_mode!

  driven_by :selenium, using: :headless_chrome do |option|
   option.add_argument('--no-sandbox')
   option.add_argument('--headless')
   option.add_argument("--disable-dev-shm-using")
   option.add_argument("--disable-extensions")
   option.add_argument("--disable-gpu")
   option.add_argument("--remote-debugging-port=9222")
  end

end


# require "test_helper"
#
# class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
#
#   include Warden::Test::Helpers
#   Warden.test_mode!
#
#   # after do
#   #   Warden.test_reset!
#   # end
#
#   Capybara.register_driver(:headless_chrome) do |app|
#     capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
#       chromeOptions: { args: %w[headless disable-gpu no-sandbox disable-dev-shm-usage] }
#       driver = webdriver.Chrome('/usr/bin/chromedriver',chrome_options=chromeOptions)
#     )
#
#     Capybara::Selenium::Driver.new(
#       app, browser: :chrome, desired_capabilities: capabilities)
#   end
#   Capybara.save_path = "tmp/"
#
#   driven_by :headless_chrome
#   # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
#
# end
