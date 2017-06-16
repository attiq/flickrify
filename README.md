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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/attiq/flickrify. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

