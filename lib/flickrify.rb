require "flickrify/version"
require 'flickraw'
require 'csv'
require "open-uri"
require 'mini_magick'

module Flickrify

  def self.search_photos(params)

    api_key = params[:api_key]
    secret = params[:shared_secret]
    search_terms = params[:search_terms]
    width = params[:width].to_i
    height = params[:height].to_i
    path = params[:path]
    results = []

    # Connecting with Flickr APi
    flickr = Flickrify.connect(api_key, secret)

    while results.size < 10 do
      failed_terms = []
      search_terms.each do |term|
        break if results.size == 10 #breaks if 10 photos are downloaded
        begin
          #Searching list of photos for the given search term
          list = flickr.photos.search(text: term, sort: 'interestingness-desc')

          sizes = flickr.photos.getSizes :photo_id => list[0].id
          photo = sizes[sizes.length - 1]
          source = photo["source"]
          photo_title = photo["source"].split("/").last

          # Downloading photos and resising them and saving them to user given path
          image = MiniMagick::Image.open(source.to_s)
          image = Flickrify.resize_and_crop(image, width, height)
          image.write("#{path}/#{photo_title}")

          results << photo_title
        rescue
          failed_terms << term
        end
      end
      #Counting and setting Search terms if given search terms are les then 10 or some of them are failed to search
      search_terms = Flickrify.parse_search_terms(search_terms, failed_terms)
    end
  end

  def self.connect(api_key, secret)
    begin
      FlickRaw.api_key = api_key
      FlickRaw.shared_secret = secret
      FlickRaw::Flickr.new
    end
  end

  def self.parse_search_terms(terms, failed = [])
    failed.each { |term| terms.delete_at(terms.index(term)) } if failed.size > 0
    return terms if terms.size >= 10
    default_terms = []
    CSV.parse(File.read(File.join(File.expand_path('../flickrify/docs'), 'search_terms.csv')), :headers => true).each { |row| default_terms << row['Term'] }
    default_size = default_terms.size
    (1..default_size).each do
      unless terms.size >= 10
        rand_term = default_terms[rand(default_size)]
        terms << rand_term if (!terms.include?(rand_term) && !failed.include?(rand_term))
      end
    end
    terms
  end

  def self.resize_and_crop(image, w, h)
    w_original =image[:width]
    h_original =image[:height]

    if (w_original*h != h_original * w)
      if w_original*h >= h_original * w
        # long width
        h_original_new = h_original
        w_original_new = h_original_new * (w.to_f / h)
      elsif w_original*h <= h_original * w
        # long height
        w_original_new = w_original
        h_original_new = w_original_new * (h.to_f / w)
      end
    else
      # good proportions
      h_original_new = h_original
      w_original_new = w_original

    end

    # v1. remove extra space

    begin
      if w_original_new != w_original
        remove = ((w_original - w_original_new)/2).round
        image.shave("#{remove}x0")
      end
      if h_original_new != h_original
        remove = ((h_original - h_original_new)/2).round
        image.shave("0x#{remove}")
      end

    end

    # v2. or use crop instead of shave
    if w_original_new != w_original || h_original_new != h_original
      x = ((w_original - w_original_new)/2).round
      y = ((h_original - h_original_new)/2).round
      image.crop ("#{w_original_new}x#{h_original_new}+#{x}+#{y}")
    end

    image.resize("#{w}x#{h}")
    return image
  end

end
