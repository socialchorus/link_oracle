class LinkOracle
  class Request
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def parsed_url
      validate_url
      validate_request
      results
    end

    def results
      {
        parsed_data: parsed_data,
        url: url
      }
    end

    def validate_request
      raise error_class if error_class
    end

    def validate_url
      !!URI.parse(url)
    rescue URI::InvalidURIError
      raise InvalidUrl
    end

    def response
      @response ||= request
    end

    def request
      ::RestClient.get url
    end

    def error_class
      return if response.code == 200
      {
        404 => PageNotFound,
        403 => PermissionDenied
      }[response.code] || BadThingsHappened
    end

    def parsed_data
      ::Nokogiri::HTML.parse(response.body)
    rescue
      raise ParsingError
    end
  end

  class PageNotFound < StandardError; end
  class PermissionDenied < StandardError; end
  class BadThingsHappened < StandardError; end
  class InvalidUrl < StandardError; end
  class ParsingError < StandardError; end
end