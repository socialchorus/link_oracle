class LinkPreview
  module Extractor
    class Meta < Base
      def type
        :meta
      end

      def title
        found = parsed_body.at_xpath("/html/head/title/text()")
        found ? [found.content] : []
      end

      def image
        get_content("/html/head/meta[contains(@name, 'thumbnail')]")
      end

      def description
        get_content("/html/head/meta[translate(
          @name,
          'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
          'abcdefghijklmnopqrstuvwxyz'
        ) = 'description']")
      end
    end
  end
end
