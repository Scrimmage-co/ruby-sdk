module Scrimmage
  module Errors
    class Base < StandardError; end

    class ConfigurationError < Base

    class MissingConfigurationError < ConfigurationError
      attr_reader :config_key

      def initialize(config_key)
        @config_key = config_key
        super("#{config_key} not configured")
      end
    end

    class AccountNotLinkedError < Base
      attr_reader :user_id

      def initialize(user_id)
        @user_id = user_id
        super('Account not linked')
      end
    end

    class InvalidPrivateKeyError < Base; end

    class RequestFailedError < Base
      attr_reader :response

      def initialize(response)
        @response = response
        super("HTTP request failed with status #{response.code}")
      end
    end
  end
end
