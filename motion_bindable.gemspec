# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require File.expand_path('../lib/motion_bindable/version.rb', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "motion_bindable"
  spec.version       = MotionBindable::VERSION
  spec.authors       = ["Nathan Kot"]
  spec.email         = ["nk@nathankot.com"]
  spec.description   = 'A simple data binding library for RubyMotion.'
  spec.summary       = 'Inspired by RivetsJS'
  spec.homepage      = "https://github.com/nathankot/motion-bindable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'bubble-wrap', '~> 1.4.0'
end
