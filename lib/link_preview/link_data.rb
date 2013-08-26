class LinkData
  attr_accessor :title, :image_url, :description, :errors

  def assign(hash)
    hash.each {|key, value| self.send("#{key}=", value) }
  end

  def error=(type)
    @errors = {
      404 => 'Page not found',
      403 => 'Permission denied',
      'invalid' => 'Invalid url'
    }[type] || "Something terrible has happened"
  end

  def errors_map
  end
end