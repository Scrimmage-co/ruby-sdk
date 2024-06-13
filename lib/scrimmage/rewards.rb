# frozen_string_literal: true

require_relative "rewards/version"

Dir[File.join(__dir__, 'rewards', '*.rb')].each { |file| require file }

module Scrimmage
  module Rewards
    @config = Scrimmage::Rewards::Config.new

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
end
