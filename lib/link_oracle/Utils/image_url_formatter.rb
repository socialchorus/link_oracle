module Utils
  class ImageUrlFormatter
    attr_reader :url, :image_url

    def initialize(url, image_url)
      @url = url
      @image_url = image_url
    end

    def perform
      return unless image_url
      invalid_url? ? "#{scheme}://#{host}#{encoded_image_url}" : encoded_image_url
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

    def invalid_url?
      !parsed_image_url.host
    end
  end
end
