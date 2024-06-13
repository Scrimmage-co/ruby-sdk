require "http"
require "json"

module Scrimmage
  module Rewards
    class Client
      attr_reader :config

      HTTP_NOT_FOUND = 404
      HTTP_UNAUTHORIZED = 401
      HTTP_FORBIDDEN = 403

      # Initialize a new client, specifying any local configuration overrides
      def initialize(**config_overrides)
        config_attrs = Scrimmage::Rewards.config.to_h.merge(config_overrides)
        @config = Scrimmage::Rewards::Config.new(**config_attrs)
      end

      def create_integration_reward(user_id, data_type, event_id_or_reward, _reward = nil)
        event_id = event_id_or_reward.is_a?(String) ? event_id_or_reward : nil
        rewardable = event_id_or_reward.is_a?(String) ? rewardable : event_id_or_reward
        private_key = config.private_key!
        service_url = config.service_url("api")
        namespace = config.namespace!

        response = HTTP.auth("Token #{private_key}")
                       .headers("Scrimmage-Namespace" => namespace)
                       .post(
                         "#{service_url}/integrations/rewards",
                         json: {
                           eventId: event_id,
                           userId: user_id,
                           dataType: data_type,
                           body: rewardable
                         }
                       )

        # handle errors
        case response.code
        when HTTP_NOT_FOUND
          raise Scrimmage::Rewards::AccountNotLinkedError, reward.user_id
        when HTTP_UNAUTHORIZED, HTTP_FORBIDDEN
          raise Scrimmage::Rewards::InvalidPrivateKeyError
        when ->(code) { !(200..299).include?(code) }
          raise Scrimmage::Rewards::RequestFailedError, response
        end

        JSON.parse(response.body.to_s, object_class: Scrimmage::Rewards::Object)
      end
    end
  end
end
