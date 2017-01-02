require "http"

module EmailService
  module Provider
    class Mailgun
      attr_reader :settings

      def initialize(settings = {})
        @settings = settings
      end

      def send(email)
        Connection.new("Mailgun").with_error_handling do
          HTTP
          .basic_auth(user: "api", pass: settings.fetch("api_key"))
          .headers(headers)
          .post(settings.fetch("api_url"), { params: data(email) })
        end
      end

      private
      def data(email)
        {
          from: settings.fetch("from", email.from),
          to: email.to,
          subject: email.subject,
          text: email.text
        }
      end

      def headers
        { "Content-Type": "application/json" }
      end
    end
  end
end
