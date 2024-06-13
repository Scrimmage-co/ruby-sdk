# frozen_string_literal: true

require_relative "scrimmage/version"

Dir[File.join(__dir__, 'scrimmage', '*.rb')].each { |file| require file }

module Scrimmage
  @config = Scrimmage::Config.new(
    secure: true,
    retry: {
      tries: 3,
      sleep_base: (100 / 1000.0),
      sleep: ->(n) { config.retry[:sleep_base] * 2**n }
    }

  )

  module_function def configure
    yield @config
  end

  module_function def config
    if block_given?
      yield @config
    else
      @config
    end
  end

  module_function def default_client
    @default_client ||= Scrimmage::Client.new
  end
end
