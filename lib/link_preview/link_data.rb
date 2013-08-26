class LinkData
  attr_accessor :errors

  def assign(hash)
    hash.each {|key, value| self.send("#{key}=", value) }
  end

  #TODO: Need to write tests for these
  def title
    og_data.title || meta_data.title || body.title
  end

  def description
    og_data.description || meta_data.description|| body.description
  end

  def image_url
    og_data.image_url || meta_data.image_url || body.image_url
  end

  def og
    @og ||= OG.new
  end

  def meta
    @meta ||= Meta.new
  end

  def body
    @body ||= Body.new
  end

  def error=(type)
    @errors = {
      404 => 'Page not found',
      403 => 'Permission denied',
      'invalid' => 'Invalid url'
    }[type] || "Something terrible has happened"
  end
end