module EmailService
  class Email
    attr_reader :provider

    PROVIDERS = [
      Provider::Fake
    ]

    def initialize
      @providers = PROVIDERS.dup
    end

    def sent?
      !!@sent
    end

    def send!(provider = nil)
      begin
        provider ||= fetch_provider
        provider.send(self)
        mark_as_sent!(provider)
      rescue Provider::Error
        retry
      end
    end

    private
    def mark_as_sent!(provider)
      @sent = true
      @provider = provider.class
    end

    def fetch_provider!
      klass = @providers.pop || (raise Provider::ProviderNotFound)
      klass.new
    end
  end
end
