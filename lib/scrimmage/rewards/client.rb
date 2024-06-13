module Scrimmage
  module Rewards
    class Client

      # Initialize a new client, specifying any local configuration overrides
      def initialize(**config_overrides)
        config_attrs = Scrimmage::Rewards.config.to_h.merge(config_overrides)
        @config = Scrimmage::Rewards::Config.new(**config_attrs)
      end

    end
  end
end
