class LinkOracle
  module Extractor
    class OG < Base
      def type
        :og
      end

      def title
        get_content("//meta[@property='og:title']")
      end

      def image
        return image_data if !image_data.first
        image_is_path? ? [] : image_data
      end

      def description
        get_content("//meta[@property='og:description']")
      end

      def image_is_path?
        !!(image_data.first.match(/\A\//))
      end

      def image_data
        get_content("//meta[@property='og:image']")
      end
    end
  end
end
