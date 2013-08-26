# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'link_preview/extractor/base'
require 'link_preview/version'

Gem::Specification.new do |spec|
  spec.name          = "link_preview"
  spec.version       = LinkPreview::VERSION
  spec.authors       = ["Ian Cooper", 'Fito von Zastrow', 'Kane Baccigalupi']
  spec.email         = ["developers@socialchorus.com"]
  spec.description   = %q{Scrapes pages for open graph, meta, and lastly, body preview data}
  spec.summary       = %q{Scrapes pages for open graph, meta, and lastly, body preview data}
  spec.homepage      = "http://github.com/socialchorus/link_preview"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
