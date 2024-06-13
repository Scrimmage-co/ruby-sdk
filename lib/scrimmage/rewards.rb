# frozen_string_literal: true

module Scrimmage
  class Rewards
    attr_reader :client

    def initialize(client: Scrimmage.default_client)
      @client = client
    end

    #
    # Track one or multiple rewards
    #
    # @param [String] user_id
    # @param [String] data_type
    # @param [Array<Hash>] rewards
    #
    # @return [Array<Scrimmage::Object>]
    #
    def track_rewardable(user_id, data_type, rewards = [])
      rewards = [rewards] unless rewards.is_a? Array
      rewards.map do |reward|
        client.create_integration_reward(user_id, data_type, reward)
      end
    end

    #
    # Track Rewardable with a single event
    #
    # @param [String] user_id
    # @param [String] data_type
    # @param [String] unique_id
    # @param [Hash] reward
    #
    # @return [Scrimmage::Object]
    #
    def track_rewardable_once(user_id, data_type, unique_id, reward)
      client.create_integration_reward(user_id, data_type, unique_id, reward)
    end

    # delegate class methods to new instance
    class << self
      extend Forwardable
      def_delegators :new, :track_rewardable, :track_rewardable_once
    end
  end
end
