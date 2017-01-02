module EmailService
  module Provider
    require "email_service/provider/fake"
    require "email_service/provider/send_grid"
    require "email_service/provider/mailgun"
  end
end
