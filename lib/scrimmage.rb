# frozen_string_literal: true

require_relative "scrimmage/version"

Dir[File.join(__dir__, 'scrimmage', '*.rb')].each { |file| require file }

module Scrimmage
  @config = Scrimmage::Config.new

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
end
