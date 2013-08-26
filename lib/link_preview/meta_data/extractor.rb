require 'pry'
class LinkData
  class Meta
    class Extractor
      attr_accessor :link_data
      attr_reader :parsed_body

      def initialize(parsed_body, link_data)
        @parsed_body = parsed_body
        @link_data = link_data
      end

      def perform
        link_data.meta.assign({
          title: title,
          image_url: image && image[:content],
          description: description && description[:content]
        })
      end

      def title
        @title ||= parsed_body.at_xpath("/html/head/title/text()").text if parsed_body.at_xpath("/html/head/title/text()")
      end

      def image
        @image ||= parsed_body.xpath("/html/head/meta[contains(@name, 'thumbnail')]").first
      end

      def description
        @description ||= parsed_body.xpath("/html/head/meta[translate(
          @name,
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          'abcdefghijklmnopqrstuvwxyz'
        ) = 'description']").first
      end
    end
  end
end