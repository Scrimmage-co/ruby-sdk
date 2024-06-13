module Scrimmage
  module Rewards
    class Config < Struct.new(
      keyword_init: true
    ); end

    @config = Config.new()

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
