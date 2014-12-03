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
      encoded_url = encode_url(url)
      !!URI.parse(encoded_url)
    rescue URI::InvalidURIError
      raise InvalidUrl, url
    end

    def encode_url(url)
      return if url.nil? || url.empty?
      URI.encode(url)
    end

    def response
      @response ||= request
    end

    def request
      c = ::Curl::Easy.new(url)
      c.follow_location = true
      c.max_redirects = 100 #there will never ever be this many redirects unless it's looping. #sorrynotsorry
      c.headers["User-Agent"] = "link_oracle#{LinkOracle::VERSION}"
      begin
        c.perform
      rescue ::Curl::Err::SSLConnectError
        c.ssl_version = 3
        c.perform
      end
      c
    rescue Curl::Err::HostResolutionError
      raise ServerNotFound
    rescue Curl::Err::SSLCACertificateError, Curl::Err::SSLPeerCertificateError
      raise BadSslCertificate
    end

    def error_class
      return if response.response_code == 200
      {
        404 => PageNotFound,
        403 => PermissionDenied
      }[response.response_code] || BadThingsHappened
    end

    def parsed_data
      ::Nokogiri::HTML.parse(response.body_str)
    rescue
      raise ParsingError
    end
  end

  class PageNotFound < StandardError; end
  class ServerNotFound < StandardError; end
  class PermissionDenied < StandardError; end
  class BadThingsHappened < StandardError; end
  class InvalidUrl < StandardError; end
  class ParsingError < StandardError; end
  class BadSslCertificate < StandardError ; end
end
