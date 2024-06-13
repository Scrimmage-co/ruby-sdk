# frozen_string_literal: true

Scrimmage::Rewards::Config = Struct.new(:api_server_endpoint, :private_key, :namespace, keyword_init: true) do |klass|
  # define e.g. private_key! to fetch struct member or raise an error
  klass.members.each do |member_key|
    define_method "#{member_key}!" do
      raise Scrimmage::Rewards::Errors::MissingConfigurationError(member_key) unless send(member_key)

      send(member_key)
    end
  end

  def service_url(service)
    "#{api_server_endpoint}/#{service}"
  end
end
