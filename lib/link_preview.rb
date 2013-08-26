require "link_preview/version"
require "rest-client"
require 'nokogiri'
require 'uri'


class LinkPreview
  def self.extract_from(url)
    LinkData::Factory.new(url).extract
  end
end