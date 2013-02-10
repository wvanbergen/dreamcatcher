# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dreamcatcher/version'

Gem::Specification.new do |gem|
  gem.name          = "dreamcatcher"
  gem.version       = Dreamcatcher::VERSION
  gem.authors       = ["Willem van Bergen"]
  gem.email         = ["willem@railsdoctors.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{Catch}
  gem.homepage      = "https://github.com/wvanbergen/dreamcatcher"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("pony")
end
