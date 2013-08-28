# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'link_oracle/version'


Gem::Specification.new do |spec|
  spec.name          = "link_oracle"
  spec.version       = LinkOracle::VERSION
  spec.authors       = ["Ian Cooper", 'Fito von Zastrow', 'Kane Baccigalupi']
  spec.email         = ["developers@socialchorus.com"]
  spec.description   = %q{Scrapes pages for open graph, meta, and lastly, body preview data}
  spec.summary       = %q{Scrapes pages for open graph, meta, and lastly, body preview data}
  spec.homepage      = "http://github.com/socialchorus/link_oracle"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
