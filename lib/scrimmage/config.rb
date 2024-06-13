# frozen_string_literal: true

Scrimmage::Config = Struct.new(
  :api_server_endpoint,
  :private_key,
  :namespace,
  :secure,
  :retry,
  keyword_init: true
) do |klass|

  def initialize(**args)
    super(**args)
    validate_protocol!
  end

  # define e.g. private_key! to fetch struct member or raise an error
  klass.members.each do |member_key|
    define_method "#{member_key}!" do
      raise Scrimmage::Errors::MissingConfigurationError(member_key) unless send(member_key)

      send(member_key)
    end
  end

  def service_url(service)
    "#{api_server_endpoint}/#{service}"
  end

  private def validate_protocol!
    protocol_regex = secure ? /^https:\/\/.+/ : /^https?:\/\/.+/
    unless api_server_endpoint.match?(protocol_regex)
      raise Scrimmage::Errors::ConfigurationError("Service URL must start with http#{secure ? 's' : ''}://")
    end
  end
end
