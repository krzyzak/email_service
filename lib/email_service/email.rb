module EmailService
  class Email < Dry::Struct
    constructor_type :strict
    attr_reader :provider

    attribute :text, Types::String
    attribute :from, Types::String
    attribute :to, Types::String
    attribute :subject, Types::String

    def sent?
      !!@sent
    end

    def error?
      !!@error
    end

    def send(provider = nil)
      begin
        send!(provider)
      rescue Connection::NoMoreProviders
        @error = true
      end
      self
    end

    def send!(provider = nil)
      begin
        provider ||= fetch_provider!
        EmailService.logger.debug "Switching to #{provider.class}..."
        provider.send(self)
        mark_as_sent!(provider)
        EmailService.logger.debug "Email successfully send!"
      rescue Connection::Error
        provider = nil
        retry
      end
    end

    private
    def providers
      @providers ||= EmailService.config.providers.dup
    end

    def mark_as_sent!(provider)
      @sent = true
      @provider = provider.class
    end

    def fetch_provider!
      klass = providers.shift || (raise Connection::NoMoreProviders)
      klass.new
    end
  end
end
