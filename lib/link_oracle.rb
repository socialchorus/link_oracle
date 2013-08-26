require "rest-client"
require 'nokogiri'
require 'uri'


class LinkOracle
  def self.extract_from(url)
    parsed_data = LinkOracle::Request.new(url).parsed_data
    LinkData.new(parsed_data)
  end
end