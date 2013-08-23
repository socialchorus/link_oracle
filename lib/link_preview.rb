require "link_previews/version"
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

class LinkData
  attr_accessor :title, :image_url, :description, :errors

  def assign(hash)
    hash.each {|key, value| self.send("#{key}=", value) }
  end

  def error=(type)
    @errors = {
      404 => 'Page not found',
      403 => 'Permission denied',
      'invalid' => 'Invalid url'
    }[type] || "Something terrible has happened"
end

  def errors_map
  end
end

require 'uri'
module LinkPreview
  class Factory
    attr_accessor :url, :link_data
    include ::UrlUtils

    def initialize(url)
      @url = urlify url
      @link_data = LinkData.new()

    end

    def self.extract(url)
      new(url).extract
    end

    def extract
      assign_errors unless valid?
      build_preview
      link_data
    end

    def valid?
      valid_url? && valid_response?
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

    def assign_errors
      link_data.error = (response && response.code) || 'invalid'
    end

    def build_preview
      link_data.assign({
        title: title && title[:content],
        image_url: image && image[:content],
        description: description && description[:content]
      })
    end

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
      ::RestClient.get url if valid_url?
    end
  end
end