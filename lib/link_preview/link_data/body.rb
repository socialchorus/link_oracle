class LinkData
  class Body
    attr_accessor :titles, :descriptions, :image_urls


    def assign(hash)
      hash.each {|key, value| self.send("#{key}=", value) }
    end

    def image_url
      image_urls.first
    end

    #def title
    #  titles.first
    #end

    #def description
    #  descriptions.first
    #end
  end
end