# encoding: UTF-8

# 
# Copyright:: Copyright 2012 by Lifted Studios. All Rights Reserved.
# 

lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'garnet/version'

Gem::Specification.new do |s|
  s.name        = 'garnet'
  s.version     = Garnet::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Lee Dohm']
  s.email       = ['lee@liftedstudios.com']
  s.homepage    = 'https://github.com/lee-dohm/garnet'
  s.summary     = 'Accepts data and transforms it into SVG charts.'
  s.description = 'Accepts data and transforms it into SVG charts.'

  s.required_ruby_version = '>= 1.9.2'
  s.required_rubygems_version = '~> 1.3'
  
  s.require_path = 'lib'

  s.add_runtime_dependency 'builder', '~> 3.0'

  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'minitest', '~> 3.0'
  s.add_development_dependency 'nokogiri', '~> 1.5'
  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'yard', '~> 0.8'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files`.split("\n").select { |f| f =~ /^spec/ }
end
