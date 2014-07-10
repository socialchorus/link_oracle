class LinkOracle
  module Extractor
    class Base
      attr_reader :parsed_body, :url, :link_data

      def initialize(parsed_url)
        @parsed_body = parsed_url[:parsed_data]
        @url = parsed_url[:url]
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
        (found && !found[:content].empty?) ? [found[:content]] : []
      end
    end
  end
end
