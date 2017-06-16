# Flickrify

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flickrify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flickrify

## Getting Started

You need to first get an API key as detailed here:

http://www.flickr.com/services/api/misc.api_keys.html

## Usage

### Search Example

```ruby
require 'flikrify'

params = {  api_key: "< FLickr API KEY>",
            shared_secret: "< FLickr API Secret>",
            width: 150,
            height: 200,
            path: "< path to save photos >"
  }

photos = Flickrify.search_photos(params)

```

### Another Search Example

If searching for photos by specific search terms then you need to specify the 'search_terms'

```ruby
require 'flikrify'

params = {  api_key: "< FLickr API KEY>",
            shared_secret: "< FLickr API Secret>",
            search_terms: ["weather", "maps", "news", "calculator", "dictionary", "movies", "horoscope", "games", "love", "prince"],
            width: 150,
            height: 200,
            path: "< path to save photos >"
  }

photos = Flickrify.search_photos(params)

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/flickrify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

