class LinkOracle
  module Extractor
    class Body < Base
      def type
        :body
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
        @images ||= valid_size_images
      end

      def parsed_images
        @parsed_images ||= parsed_body.xpath(
          "//img[@src[(contains(.,'://') or contains(., '/')) and not(contains(.,'ads.') or contains(.,'ad.') or contains(.,'?') or contains(.,'.gif'))]]"
        ).map{ |node| node['src'] }
      end

      def formatted_images
        parsed_images.map { |image_url| ::Utils::ImageUrlFormatter.new(url, image_url).perform }
      end

      def valid_size_images
        formatted_images.select do |image|
          size = image_size(image)
          size[0] >= 100 && size[1] >= 100 if size
        end
      end

      def image_size(image)
        ::FastImage.size(image)
      rescue ::URI::InvalidURIError
        [0, 0]
      end

      def descriptions
        @description ||= parsed_body.xpath("//p/text()").first(3).compact.map{ |text| text.content }
      end
    end
  end
end
