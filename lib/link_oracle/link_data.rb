class LinkOracle
  class LinkData
    attr_reader :parsed_url

    def initialize(parsed_url)
      @parsed_url = parsed_url
    end

    #TODO: Need to write tests for these
    def title
      title = og.title || meta.title || body.title
      title.strip if title
    end

    def description
      description = og.description || meta.description || body.description
      description.strip if description
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
