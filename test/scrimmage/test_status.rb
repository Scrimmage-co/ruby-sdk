# frozen_string_literal: true

require "test_helper"

module Scrimmage
  class TestStatus < Minitest::Test
    def test_verify
      result = Scrimmage::Status.verify

      assert result[:verified]
      assert_empty result[:errors]
    end
  end
end
