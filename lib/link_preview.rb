require "rest-client"
require 'nokogiri'
require 'uri'


class LinkPreview
  def self.extract_from(url)
    parsed_data = LinkPreview::Request.new(url).parsed_data
    LinkData.new(parsed_data)
  end
end