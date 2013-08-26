class LinkData
  class OG
    class Extractor
      attr_accessor :link_data
      attr_reader :parsed_body

      def initialize(parsed_body, link_data)
        @parsed_body = parsed_body
        @link_data = link_data
      end

      def perform
        link_data.og.assign({
          title: title && title[:content],
          image_url: image && image[:content],
          description: description && description[:content]
        })
      end

      def title
        @title ||= parsed_body.xpath("/html/head/meta[@property='og:title']").first
      end

      def image
        @image ||= parsed_body.xpath("/html/head/meta[@property='og:image']").first
      end

      def description
        @description ||= parsed_body.xpath("/html/head/meta[@property='og:description']").first
      end
    end
  end
end