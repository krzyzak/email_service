module EmailService
  module Provider
    class Fake
      def send(email)
        true
      end
    end
  end
end
