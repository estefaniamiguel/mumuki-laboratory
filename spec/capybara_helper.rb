require 'capybara/rails'
require 'capybara/rspec'

Capybara.app_host = Rails.configuration.base_url
Capybara.server_host = Rails.configuration.domain
Capybara.server_port = '3000'
