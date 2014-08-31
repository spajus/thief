# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'thief/version'

Gem::Specification.new do |spec|
  spec.name          = "thief"
  spec.version       = Thief::VERSION
  spec.authors       = ["Tomas Varaneckas"]
  spec.email         = ["tomas.varaneckas@gmail.com"]
  spec.summary       = %q{A faster yet more crude version of "bundle install"}
  spec.description   = %q{Provides alternative, faster way of installing your Gemfile contents}
  spec.homepage      = "https://github.com/spajus/thief"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['thief']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'parallel'
  spec.add_runtime_dependency 'ruby-progressbar'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
