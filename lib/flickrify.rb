require "flickrify/version"
require 'flickraw'
require 'csv'
require 'logger'
require "open-uri"
require 'rmagick'

module Flickrify

  def self.search_photos(search_terms = [], path)

    #Initializing Logger
    @logger = Logger.new(STDOUT)
    @logger.level = Logger::WARN

    # Connecting with Flickr APi
    flickr = Flickrify.connect

    results = []
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

          # Downloading photos and saving them in temp dir
          File.open("tmp/#{photo_title}", 'wb') do |fo|
            fo.write open(source.to_s).read
          end
          results << photo_title
        rescue => e
          @logger.info("Failed to search photos for : #{term}. Error: #{e.inspect}")
          failed_terms << term
        end
      end
      #Counting and setting Search terms if given search terms are les then 10 or some of them are failed to search
      search_terms = Flickrify.parse_search_terms(search_terms, failed_terms)
    end

    # Croping and Saving Downladed Images to the user given dir path
   # Flickrify.crop_and_save(path)
  end

  def self.connect
    begin
      FlickRaw.api_key = "52a9382944cfd5b900b7af9c4ca84553"
      FlickRaw.shared_secret = "92831b8c738df632"
      FlickRaw::Flickr.new
    rescue => e
      @logger.info("Failed to connect with Flickr API : #{e.inspect}")
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

  def self.crop_and_save(path)
    dir_path = File.join(File.expand_path('../flickrify'), 'tmp')
    Dir.open(dir_path).each do |filename|
      image = Magick::Image::read("#{dir_path}/#{filename}").first
      image.resize_to_fill(200, 100).write("#{path}/#{filename}")
    end

    # removing all downlaoded images from tem dir
    FileUtils.rm_rf(Dir.glob("#{dir_path}/*"))
  end

end
