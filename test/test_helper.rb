# frozen_string_literal: true

require "dotenv/load"
require "debug"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "scrimmage"

Scrimmage.configure do |config|
  config.api_server_endpoint = ENV.fetch("SCRIMMAGE_API_SERVER_ENDPOINT")
  config.private_key = ENV.fetch("SCRIMMAGE_PRIVATE_KEY")
  config.namespace = ENV.fetch("SCRIMMAGE_NAMESPACE")
end

require "minitest/autorun"
