class LinkOracle
  module Extractor
    class Meta < Base
      def type
        :meta
      end

      def title
        found = parsed_body.at_xpath("//title/text()")
        found ? [found.content] : []
      end

      def image
        get_content("//meta[contains(@name, 'thumbnail')]")
      end

      def description
        get_content("//meta[translate(
          @name,
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          'abcdefghijklmnopqrstuvwxyz'
        ) = 'description']")
      end
    end
  end
end
