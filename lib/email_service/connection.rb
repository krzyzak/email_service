module EmailService
  class Connection
    ApiError = Class.new(StandardError)
    Error = Class.new(StandardError)
    NoMoreProviders = Class.new(StandardError)

    attr_reader :handler

    def initialize(handler)
      @handler = handler
      @retries = 0
    end

    def with_error_handling(&block)
      begin
        response = yield

        raise ApiError, response.to_s unless response.code == 200
      rescue ApiError => error
        @retries += 1
        if @retries > EmailService.config.max_retries
          EmailService.logger.debug "[#{handler}] Giving up.."
          raise Error, error
        else
          time = EmailService.config.retry_formula.call(@retries)
          EmailService.logger.debug "[#{handler}] Retrying in #{time}..."
          sleep(time)
          retry
        end
      end

      true
    end
  end
end
