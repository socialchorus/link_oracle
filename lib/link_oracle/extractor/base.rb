class LinkOracle
  module Extractor
    class Base
      attr_reader :parsed_body, :link_data

      def initialize(parsed_body)
        @parsed_body = parsed_body
        @link_data = LinkData::Data.new
      end

      def type
        raise "implement me"
      end

      def perform
        link_data.assign({
          titles: title,
          image_urls: image,
          descriptions: description
        })
      end

      def get_content(selector)
        found = parsed_body.xpath(selector).first
        found ? [found[:content]] : []
      end
    end
  end
end