class LinkData
  class Factory
    attr_accessor :url, :link_data
    include ::UrlUtils

    def initialize(url)
      @url = urlify url
      @link_data = LinkData.new()
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
      OG::Extractor.new(parsed_body, link_data).perform
    end

    def parsed_body
      @parsed_body ||= ::Nokogiri::HTML.parse(response.body)
    end

    def response
      @response ||= request
    end

    def request
      ::RestClient.get url if valid_url?
    end
  end
end