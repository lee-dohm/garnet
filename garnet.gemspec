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

  s.required_rubygems_version = '~> 1.3'

  s.add_runtime_dependency 'builder'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'nokogiri'
  s.add_development_dependency 'reek'
  s.add_development_dependency 'yard'

  s.files = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md)
  s.require_path = 'lib'
end
