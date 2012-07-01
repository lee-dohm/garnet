# 
# Rakefile for the Garnet project.
# 
# Copyright:: Copyright (c) 2012 by Lifted Studios.  All Rights Reserved.
# 

require 'lifted'
require 'rake/clean'
require 'rake/testtask'
require 'yard'

CLEAN.include('.yardoc')
CLOBBER.include('doc')

task :default => [:test, :yard]

desc "Execute all tests"
task :test => [:static, :spec]

desc "Perform static analysis"
task :static => [:syntax]

Lifted::Rake::SyntaxTask.new

Rake::TestTask.new('spec') do |spec|
  spec.libs << 'spec'
  spec.test_files = Dir['spec/**/*_spec.rb']
  spec.warning = true
end

YARD::Rake::YardocTask.new
