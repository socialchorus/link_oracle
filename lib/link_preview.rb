require "link_preview/version"
require "rest-client"
require 'nokogiri'

module UrlUtils
  def urlify(url)
    url.to_s.strip!
    return if url.empty?

    if !url.match(%r{^http(?:s)?://})
      url = "http://" + url
    end

    url = nil if url=~%r{^http(?:s)?://$}

    url
  end
end

require 'uri'
module LinkPreview
  class Factory
    attr_accessor :url
    include ::UrlUtils

    def initialize(url)
      @url = urlify url
    end

    def self.create(url)
      new(url).create
    end

    def create
      return errors unless valid?
      {
        title: title && title[:content],
        image_url: image && image[:content],
        description: description && description[:content]
      }
    end

    def errors
      {errors: 'Invalid Url'}
    end

    def valid?
      valid_url? && valid_response? && og_data?
    end

    def og_data?

    end

    def valid_url?
      !!URI.parse(url)
    rescue URI::InvalidURIError
      false
    end

    def valid_response?
      response.code == 200
    end

    private

    def parsed_body
      @parsed_body ||= ::Nokogiri::HTML.parse(response.body)
    end

    def title
      @title ||= parsed_body.xpath("/html/head/meta[@property='og:title']").first
    end

    def image
      @image ||= parsed_body.xpath("/html/head/meta[@property='og:image']").first
    end

    def description
      @description ||= parsed_body.xpath("/html/head/meta[@property='og:description']").first
    end

    def response
      @response ||= request
    end

    def request
      ::RestClient.get url
    end
  end
end