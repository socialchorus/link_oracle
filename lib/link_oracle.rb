require "rest-client"
require 'nokogiri'
require 'uri'

require 'link_oracle/extractor/base'
require 'link_oracle/request'
require 'link_oracle/link_data'
Dir["#{File.dirname(__FILE__)}/link_oracle/**/*.rb"].each {|f| require f}


class LinkOracle
  def self.extract_from(url)
    parsed_data = LinkOracle::Request.new(url).parsed_data
    LinkData.new(parsed_data)
  end
end