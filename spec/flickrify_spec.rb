require "spec_helper"

RSpec.describe Flickrify do
  it "has a version number" do
    expect(Flickrify::VERSION).not_to be nil
  end

  it "it should search the photos for given 10 search terms" do
    Flickrify.search_photos(["term 1", "term 2", "term 3", "term 4", "term 5", "term 6", "term 7", "term 8", "term 9", "term 10"], "../rails_apps")
  end

  it "it should search 10 photos for given 5 search terms" do
    Flickrify.search_photos(["term 1", "term 2", "term 3", "term 4", "term 5"], "../rails_apps")
  end

  it "it should search 10 photos for given unsearchable terms" do
    Flickrify.search_photos(["term 1", "term 2", "term 3", "term 4", "term 5"], "../rails_apps")
  end

end
