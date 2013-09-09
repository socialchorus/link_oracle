module Utils
  class ImageUrlFormatter
    attr_reader :url, :image_url

    def initialize(url, image_url)
      @url = url
      @image_url = image_url
    end

    def perform
      invalid_url? ? "#{scheme}://#{host}#{image_url}" : image_url
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

    def invalid_url?
      image_url[0] == '/'
    end
  end
end