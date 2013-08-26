class LinkOracle
  module Extractor
    class OG < Base
      def type
        :og
      end

      def title
        get_content("/html/head/meta[@property='og:title']")
      end

      def image
        get_content("/html/head/meta[@property='og:image']")
      end

      def description
        get_content("/html/head/meta[@property='og:description']")
      end
    end
  end
end