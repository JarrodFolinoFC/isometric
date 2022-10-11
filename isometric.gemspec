# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'isometric'
  s.version     = '0.0.2'
  s.summary     = 'Isometric'
  s.description = 'A framework for Ruby microservices'
  s.authors     = ['Jarrod Folino']
  s.email       = 'jdfolino@icloud.com'
  s.files       = Dir.glob('lib/**/*')
  s.homepage    = 'https://rubygems.org/gems/heart_core'
  s.license     = 'MIT'
  s.required_ruby_version = '2.5.9'
  s.add_dependency 'activerecord', '~> 5.0.3'
  s.add_dependency 'bunny', '~> 2.19.0'
  s.add_dependency 'redis', '~> 5.0.3'
end
