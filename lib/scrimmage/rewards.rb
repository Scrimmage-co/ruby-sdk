# frozen_string_literal: true

require_relative "rewards/version"

Dir[File.join(__dir__, 'rewards', '*.rb')].each { |file| require file }

module Scrimmage
  module Rewards
    class Error < StandardError; end
    # Your code goes here...
  end
end
