class LinkOracle
  class LinkData
    attr_reader :parsed_url

    def initialize(parsed_url)
      @parsed_url = parsed_url
    end

    #TODO: Need to write tests for these
    def title
      (og.title || meta.title || body.title).strip
    end

    def description
      (og.description || meta.description || body.description).strip
    end

    def image_url
      og.image_url || meta.image_url || body.image_url
    end

    def og
      @og ||= Extractor::OG.new(parsed_url).perform
    end

    def meta
      @meta ||= Extractor::Meta.new(parsed_url).perform
    end

    def body
      @body ||= Extractor::Body.new(parsed_url).perform
    end
  end
end
