# frozen_string_literal: true

require "test_helper"

module Scrimmage
  class TestUsers < Minitest::Test
    def test_get_user_token
      assert Scrimmage::Users.get_user_token(
        "ruby_test_user",
        tags: ["ruby-test-tag"],
        properties: { "ruby-prop-1" => "value", "ruby-prop-2" => 124 }
      )
    end
  end
end
