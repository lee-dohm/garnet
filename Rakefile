# 
# Rakefile for the ruby-chart project.
# 
# Copyright:: Copyright (c) 2012 by Lifted Studios.  All Rights Reserved.
# 

require 'rake/clean'
require 'rake/testtask'
require 'yard'

CLEAN.include('.yardoc')
CLOBBER.include('doc')

task :default => [:test, :doc]

desc "Create documentation"
task :doc => :yard

desc "Execute all tests"
task :test => [:spec]

Rake::TestTask.new('spec') do |spec|
  spec.libs << 'spec'
  spec.test_files = Dir['spec/**/*_spec.rb']
  spec.warning = true
end

YARD::Rake::YardocTask.new
