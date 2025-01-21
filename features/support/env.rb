# features/support/env.rb
require 'cucumber/rails'

# Capybara para interação com o navegador
require 'capybara/cucumber'

# Se estiver usando o Rails, você pode configurar o Capybara para usar o navegador em modo headless (sem interface gráfica)
Capybara.default_driver = :selenium_chrome_headless
