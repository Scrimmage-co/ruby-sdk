require "http"
require "json"
require "retryable"

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

      response = http_request(
        :post,
        url("/integrations/rewards"),
        json: {
          eventId: event_id,
          userId: user_id,
          dataType: data_type,
          body: rewardable
        }
      ) do |my_response|
        # handle errors
        case my_response.code
        when HTTP_NOT_FOUND
          raise Scrimmage::AccountNotLinkedError, reward&.user_id
        when HTTP_UNAUTHORIZED, HTTP_FORBIDDEN
          raise Scrimmage::InvalidPrivateKeyError
        when ->(code) { !(200..299).include?(code) }
          raise Scrimmage::RequestFailedError, response
        end
      end

      parse_data(response)
    end

    def get_user_token(user_id, **options)
      response = http_request(
        :post,
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
      response = http_request(:get, my_url)
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
      response_data.all? { |d| d&.uptime&.positive? }
    end

    def get_rewarder_key_details
      url = url("/rewarders/keys/@me")
      response = http_request(:get, url)

      parse_data(response)
    end

    private def http_client
      private_key = config.private_key!
      namespace = config.namespace!

      HTTP.auth("Token #{private_key}")
          .headers("Scrimmage-Namespace" => namespace)
    end

    #
    # Initiate an authorized http request
    #
    # @param [Symbol] method HTTP method (get, post, etc)
    # @param [String] uri Full URL of the request (build with #url)
    # @param [Hash] options Options for the request (e.g. json body)
    # @param [Proc] &block Block to override default response validation
    #
    # @return [HTTP::Response]
    #
    private def http_request(method, uri, options = {}, &block)
      request_proc = ->(*args) {
        response = http_client.request(method, uri, options)

        if block
          block.call(response)
        else
          Scrimmage::Errors::RequestFailedError unless (200..299).include?(response.code)
        end
        response
      }

      if config.retry
        Retryable.retryable(tries: config.retry[:tries], sleep: config.retry[:sleep], &request_proc)
      else
        request_proc.call
      end
    end

    private def url(path, service: "api")
      service_url = config.service_url(service)
      service_url + path
    end

    private def parse_data(response)
      JSON.parse(response.body.to_s, object_class: Scrimmage::Object)
    end
  end
end
