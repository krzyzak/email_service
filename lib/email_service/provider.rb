module EmailService
  module Provider
    require "email_service/provider/fake"

    Error = Class.new(StandardError)
    ProviderNotFound = Class.new(StandardError)
  end
end
