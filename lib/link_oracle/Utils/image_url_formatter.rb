module Utils
  class ImageUrlFormatter
    attr_reader :url, :image_url

    def initialize(url, image_url)
      @url = url
      @image_url = image_url
    end

    def perform
      return unless image_url
      if host_missing?
        "#{scheme}://#{host}#{encoded_image_url}"
      elsif scheme_missing?
        "http:#{encoded_image_url}"
      else
        encoded_image_url
      end
    end

    def encoded_image_url
      URI.encode(image_url)
    end

    def host
      parsed_url.host
    end

    def scheme
      parsed_url.scheme
    end

    def parsed_url
      @parsed_url ||= URI.parse(url)
    end

    def parsed_image_url
      @parsed_image_url ||= URI.parse(encoded_image_url)
    end

    def scheme_missing?
      parsed_image_url.scheme.to_s.empty?
    end

    def host_missing?
      !parsed_image_url.host
    end
  end
end
