# frozen_string_literal: true

require "test_helper"

class Scrimmage::TestClient < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Scrimmage::VERSION
  end

  def setup
    @client = Scrimmage::Client.new
  end

  def test_get_overall_status
    assert @client.get_overall_service_status
  end

  def test_rewarder_key_details
    assert @client.get_rewarder_key_details.id
  end

  def test_get_user_token
    token = @client.get_user_token(
      "ruby_test_user",
      tags: ["ruby-test-tag"],
      properties: {"ruby-prop-1" => "value", "ruby-prop-2" => 124}
    )
    assert token
  end

  def test_create_integration_reward
    result = @client.create_integration_reward(
      "ruby_test_user",
      "ruby_test",
      {value: 1}
    )
    assert result
  end

end
