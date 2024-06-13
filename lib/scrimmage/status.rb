# frozen_string_literal: true

module Scrimmage
  class Status
    attr_reader :client

    def initialize(client: Scrimmage.default_client)
      @client = client
    end

    #
    # Verify API Service Status
    #
    # @return [Hash{verified: Boolean, errors: Array<String>}] A hash object indicating service status
    #
    def verify
      verified = true
      errors = []

      unless client.get_overall_service_status
        verified = false
        errors << "Rewarder API is not available"
      end

      begin
        client.get_rewarder_key_details
      rescue Scrimmage::Errors::RequestFailedError
        verified = false
        errors << "Rewarder API key is invalid"
      end
      { verified: verified, errors: errors }
    end

    # delegate class methods to new instance
    class << self
      extend Forwardable
      def_delegators :new, :verify
    end
  end
end
