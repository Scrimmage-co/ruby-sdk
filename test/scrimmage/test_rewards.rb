# frozen_string_literal: true

require "test_helper"

class Scrimmage::TestRewards < Minitest::Test

  def test_track_rewardable
    assert Scrimmage::Rewards.track_rewardable(
      "ruby_test_user",
      "ruby_test_type",
      [{value: 2}, {value: 4}]
    )
  end

  def test_track_rewardable_once
    assert Scrimmage::Rewards.track_rewardable_once(
      "ruby_test_user",
      "ruby_test_type",
      "ruby_test_event",
      {value: 6}
    )
  end

  def test_track_rewardable_bad_auth
    client = Scrimmage::Client.new(private_key: "BAD_KEY")
    assert_raises(Scrimmage::Errors::InvalidPrivateKeyError) do
      client.rewards.track_rewardable(
        "ruby_test_user",
        "ruby_test",
        [{value: 1}]
      )
    end
  end

end
