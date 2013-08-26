module UrlUtils
  def urlify(url)
    url.to_s.strip!
    return if url.empty?

    if !url.match(%r{^http(?:s)?://})
      url = "http://" + url
    end

    url = nil if url=~%r{^http(?:s)?://$}

    url
  end
end