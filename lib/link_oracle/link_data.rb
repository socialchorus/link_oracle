class LinkOracle
  class LinkData
    attr_reader :parsed_data, :url

    def initialize(parsed_url)
      @parsed_data = parsed_url[:parsed_data]
      @url = parsed_url[:url]
    end

    #TODO: Need to write tests for these
    def title
      og.title || meta.title || body.title
    end

    def description
      og.description || meta.description|| body.description
    end

    def image_url
      Utils::ImageUrlFormatter.new(url, og.image_url || meta.image_url || body.image_url).perform
    end

    def og
      @og ||= Extractor::OG.new(parsed_data).perform
    end

    def meta
      @meta ||= Extractor::Meta.new(parsed_data).perform
    end

    def body
      @body ||= Extractor::Body.new(parsed_data).perform
    end
  end
end
