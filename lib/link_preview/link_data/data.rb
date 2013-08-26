class LinkPreview
  class LinkData
    class Data
      attr_accessor :titles, :image_urls, :descriptions

      def assign(hash)
        hash.each {|key, value| self.send("#{key}=", value) }
        self
      end

      def image_url
        image_urls.first
      end

      def title
        titles.first
      end

      def description
        descriptions.first
      end
    end
  end
end
