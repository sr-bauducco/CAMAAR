require 'capybara/rails'
require 'capybara/cucumber'
require 'selenium-webdriver'

Capybara.default_driver = :selenium_chrome # Use o Chrome (ou altere para :selenium_firefox se preferir)

require 'database_cleaner/active_record'

Before do
  DatabaseCleaner.strategy = :transaction
  DatabaseCleaner.start
end

After do
  DatabaseCleaner.clean
end
