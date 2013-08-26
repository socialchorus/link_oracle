class LinkPreview
  module Extractor
    class Body
      attr_reader :parsed_body, :link_data

      def initialize(parsed_body)
        @parsed_body = parsed_body
        @link_data = LinkData::Data.new
      end

      def perform
        link_data.assign({
          titles: titles,
          image_urls: images,
          descriptions: descriptions
        })

      end

      def titles
        @titles ||= parsed_body.xpath(
          "//h1/text() | //h2/text() | //h3/text()"
        ).first(3).compact.map{ |text| text.content }
      end

      def images
        @images ||= parsed_body.xpath(
          "//img[@src[contains(.,'://') and not(contains(.,'ads.') or contains(.,'ad.') or contains(.,'?'))]]"
        ).first(3).compact.map{ |node| node['src'] }
      end

      def descriptions
        @description ||= parsed_body.xpath("//p/text()").first(3).compact.map{ |text| text.content }
      end
    end
  end
end