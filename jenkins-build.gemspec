# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jenkins/build/version'

Gem::Specification.new do |spec|
  spec.name          = "jenkins-build"
  spec.version       = Jenkins::Build::VERSION
  spec.authors       = ["Michal Cichra"]
  spec.email         = ["michal@3scale.net"]


  spec.summary       = %q{CLI utility to trigger jobs on jenkins.}
  spec.description   = %q{Using Github Pull Request Plugin and Jenkins with GitHub authentication}
  spec.homepage      = "https://github.com/3scale/jenkins-build"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency 'rspec', '~> 3.1'

  spec.add_dependency 'thor'
end
