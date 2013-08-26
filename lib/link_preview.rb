require "link_preview/version"
require "rest-client"
require 'nokogiri'
require 'uri'

require_relative 'link_preview/url_utils'
require_relative 'link_preview/link_data'
require_relative 'link_preview/link_data/factory'

class LinkPreview
  def self.extract_from(url)
    LinkData::Factory.new(url).extract
  end
end