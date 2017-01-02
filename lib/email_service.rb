require "dry-struct"
require "dry-types"
require "dry-configurable"
require "logger"
require "yaml"

require "email_service/version"
require "email_service/types"
require "email_service/connection"
require "email_service/provider"
require "email_service/email"

module EmailService
  extend Dry::Configurable

  setting :providers, [
    Provider::Mailgun,
    Provider::SendGrid
  ]

  setting :env, "development"
  setting :max_retries, 5
  setting :retry_formula, ->(n){ 2**n }
  setting :Mailgun
  setting :SendGrid

  def self.logger
    @logger ||= Logger.new("log/#{config.env}.log")
  end

  def self.configure!
    configure do |config|
      YAML.load_file("email_service.yml")[config.env].each do |key, value|
        config.send("#{key}=", value)
      end
    end
  end
end

EmailService.configure!
