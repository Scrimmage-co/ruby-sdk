# frozen_string_literal: true

module Scrimmage
  class Users
    attr_reader :client

    def initialize(client: Scrimmage.default_client)
      @client = client
    end

    def get_user_token(user_id, **options)
      client.get_user_token(user_id, **options)
    end

    # delegate class methods to new instance
    class << self
      extend Forwardable
      def_delegators :new, :get_user_token
    end
  end
end
