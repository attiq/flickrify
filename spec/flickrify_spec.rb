require "spec_helper"

RSpec.describe Flickrify do

  params = {api_key: "52a9382944cfd5b900b7af9c4ca84553",
            shared_secret: "92831b8c738df632",
            search_terms: ["weather", "maps", "news", "calculator", "dictionary", "movies", "horoscope", "games", "love", "prince"],
            width: 150,
            height: 200,
            path: "/tmp"
  }

  it "has a version number" do
    expect(Flickrify::VERSION).not_to be nil
  end

  it "it should search the photos for given 10 search terms" do
    Flickrify.search_photos(params)
  end

end
