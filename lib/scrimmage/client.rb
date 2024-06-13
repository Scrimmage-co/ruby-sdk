require "http"
require "json"

module Scrimmage
  class Client
    attr_reader :config, :rewards, :users, :status

    HTTP_NOT_FOUND = 404
    HTTP_UNAUTHORIZED = 401
    HTTP_FORBIDDEN = 403
    SERVICES = %w[api p2e fed nbc].freeze

    # Initialize a new client, specifying any local configuration overrides
    def initialize(**config_overrides)
      config_attrs = Scrimmage.config.to_h.merge(config_overrides)
      @config = Scrimmage::Config.new(**config_attrs)
      @rewards = Scrimmage::Rewards.new(client: self)
      @users = Scrimmage::Users.new(client: self)
      @status = Scrimmage::Status.new(client: self)
    end

    def create_integration_reward(user_id, data_type, event_id_or_reward, reward = nil)
      if event_id_or_reward.is_a? String
        event_id = event_id_or_reward
        rewardable = reward.to_h
      else
        event_id = nil
        rewardable = event_id_or_reward.to_h
      end

      response = http_client.post(
                        url("/integrations/rewards"),
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
        raise Scrimmage::AccountNotLinkedError, reward&.user_id
      when HTTP_UNAUTHORIZED, HTTP_FORBIDDEN
        raise Scrimmage::InvalidPrivateKeyError
      when ->(code) { !(200..299).include?(code) }
        raise Scrimmage::RequestFailedError, response
      end

      parse_data(response)
    end

    def get_user_token(user_id, **options)
      response = http_client.post(
        url("/integrations/users"),
        json: {
          id: user_id,
          tags: options[:tags].to_a,
          properties: options[:properties].to_h
        }
      )
      parse_data(response)&.token
    end

    #
    # Requests Service Status
    #
    # @param [String] service the code for a scrimmage service e.g. ('api', 'p2e', 'fed', 'nbc')
    #
    # @return [Scrimmage::Object] an object detailing service status
    #
    def get_service_status(service)
      my_url = url("/system/status", service: service)
      response = http_client.get(my_url)
      parse_data(response)
    end

    #
    # Request overall status for all services
    #
    # @return [Boolean] Indicates whether all services are fulfilled
    #
    def get_overall_service_status
      response_data = SERVICES.map do |service|
        get_service_status(service)
      end

      response_data.all? { |d| d&.status == "fulfilled" }
    end

    def get_rewarder_key_details
      url = url("/rewarders/keys/@me")
      response = http_client.get(url)
      raise Scrimmage::Errors::RequestFailedError unless (200..299).include?(response.code)
      parse_data(response)
    end

    private def http_client
      private_key = config.private_key!
      namespace = config.namespace!

      HTTP.auth("Token #{private_key}")
          .headers("Scrimmage-Namespace" => namespace)
    end

    private def url(path, service: "api")
      service_url = config.service_url(service)
      service_url + path
    end

    private def parse_data(response)
      JSON.parse(response.body.to_s, object_class: Scrimmage::Object).data
    end
  end
end
