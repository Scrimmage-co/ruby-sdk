# Scrimmage Rewards

The low-code loyalty program maker.

This library is a part of the [Scrimmage Rewards Program](https://scrimmage.co)
that is providing a solution for loyalty programs and rewards.

Tutorial can be found at [Scrimmage Rewards Tutorial](https://scrimmage-rewards.readme.io/docs).

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

    $ bundle add UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG

## Usage

1. Load the library (if not using bundler)
```ruby
require "scrimmage"
```

2. Initialize the library with global configuration
```ruby
# config/initializers/scrimmage.rb
Scrimmage.configure do |config|
  config.api_server_endpoint = '<your api server endpoint>'
  config.private_key = '<your private key>',
  config.namespace = '<environment, e.g. staging or production>'
end
```

3.  Use the library
    ```ruby
    Scrimmage::Rewards.track_rewardable(
      'unique-user-id',
      'Data Type Name',
      {
        'custom-property': 'custom-value',
        'custom-property-2': {
          'custom-property-2-1': 'custom-value-2-1',
        },
      },
    )
    ```

   For one-time events you can use `track_rewardable_once` method. Make sure to use unique event id.

   ```ruby
    Scrimmage::Rewards.track_rewardable_once(
      'unique-user-id',
      'Data Type Name',
      'unique-event-id',
      {
         'custom-property': 'custom-value',
         'custom-property-2': {
             'custom-property-2-1': 'custom-value-2-1',
         },
      },
    );
    ```

4. Get user token
   ```ruby
   token = Scrimmage::Users.get_user_token('unique-user-id')
   ```
   or
   ```ruby
   token = Scrimmage::Users.get_user_token('unique-user-id',
     tags: ['tag1', 'tag2'],
     properties: {
       'custom-property': 'custom-value',
       'custom-property-2': 12345,
     },
   )
   ```

  Use this token to identify the user on the frontend. Make sure to deliver the token to the frontend securely.

## Multiple connections
If you want to use multiple connections, you need to create a new instance of `Scrimmage::Client`.

```ruby
rewarder_for_production = Scrimmage::Client.new(
  api_server: '<your api server endpoint 1>',
  private_key: '<your private key 1>',
  namespace: '<environment 1, e.g. staging or production>',
)

rewarder_for_staging = Scrimmage::Client.new(
  api_server: '<your api server endpoint 2>',
  private_key: '<your private key 2>',
  namespace: '<environment 2, e.g. staging or production>',
)
```

Then you can use the two instances simultaneously.

```ruby
rewarder_for_production.rewards.track_rewardable(
  'unique-user-id',
  'Data Type Name',
  {
    'custom-property': 'custom-value',
    'custom-property-2': {
      'custom-property-2-1': 'custom-value-2-1',
    },
  },
);

rewarder_for_staging.rewards.track_rewardable(
  'unique-user-id',
  'Data Type Name',
  {
    'custom-property': 'custom-value',
    'custom-property-2': {
      'custom-property-2-1': 'custom-value-2-1',
    },
  },
);
```

## Usage on the frontend

- Using `<iframe />`: [github.com/Scrimmage-co/scrimmage-rewards-iframe](https://github.com/Scrimmage-co/scrimmage-rewards-iframe)
- Using Android: [github.com/Scrimmage-co/scrimmage-rewards-android](https://github.com/Scrimmage-co/scrimmage-rewards-android)
- Using iOS: [github.com/Scrimmage-co/scrimmage-rewards-ios](https://github.com/Scrimmage-co/scrimmage-rewards-ios)
- Using Flutter: [github.com/Scrimmage-co/scrimmage-rewards-flutter](https://github.com/Scrimmage-co/scrimmage-rewards-flutter)
- Using NodeJS: [github.com/Scrimmage-co/rewards/backend-library](https://github.com/Scrimmage-co/rewards/backend-library)

## Development

After checking out the repo, run `bin/setup` to install dependencies. To run the tests first copy `.env.example` to `.env` and fill it in with your API credentials.  Then you can run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/scrimmage-rewards. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/scrimmage-rewards/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Scrimmage::Rewards project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/scrimmage-rewards/blob/main/CODE_OF_CONDUCT.md).
