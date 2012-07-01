# 
# Rakefile for the Garnet project.
# 
# Copyright:: Copyright (c) 2012 by Lifted Studios.  All Rights Reserved.
# 

require 'bundler/gem_tasks'
require 'lifted'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

CLEAN.include('.yardoc')
CLOBBER.include('doc', 'pkg')

task :default => [:test, :yard]

desc "Execute all tests"
task :test => [:static, :spec]

desc "Perform static analysis"
task :static => [:syntax]

Rake::TestTask.new('spec') do |spec|
  spec.libs << 'spec'
  spec.test_files = Dir['spec/**/*_spec.rb']
  spec.warning = true
end

Lifted::Rake::SyntaxTask.new
YARD::Rake::YardocTask.new
