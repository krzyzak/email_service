require "http"

module EmailService
  module Provider
    class SendGrid
      API_URL = "https://api.sendgrid.com/v3/mail/send".freeze

      def initialize(settings = {})
        @settings = settings
      end

      def send(email)
        Connection.new("SendGrid").with_error_handling do
          HTTP
          .auth(auth_header)
          .headers(headers)
          .post(API_URL, { json: data(email) })
        end
      end

      private
      def data(email)
        {
          personalizations: [{
            to: [
              { email: email.to }
            ],
            subject: email.subject
          }],
          from: {
            email: email.from
          },
          content: [
            {
              type: "text/plain",
              value: email.text
            }
          ]
        }
      end

      def headers
        { "Content-Type": "application/json" }
      end

      def auth_header
        "Bearer #{settings.fetch("api_key")}"
      end
    end
  end
end
