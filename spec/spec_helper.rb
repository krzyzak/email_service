require 'bundler/setup'
Bundler.setup

require 'email_service'

RSpec.configure do |config|
end

EmailService.configure do |config|
  config.env = "test"
  config.providers = [EmailService::Provider::Fake]
end
