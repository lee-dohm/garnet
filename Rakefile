# 
# Rakefile for the Garnet project.
# 
# Copyright:: Copyright (c) 2012 by Lifted Studios.  All Rights Reserved.
# 

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

desc "Perform syntax check"
task :syntax do
  files = Dir['lib/**/*.rb']
  files.each { |file| sh "ruby -cw #{file}" }
end

Rake::TestTask.new('spec') do |spec|
  spec.libs << 'spec'
  spec.test_files = Dir['spec/**/*_spec.rb']
  spec.warning = true
end

YARD::Rake::YardocTask.new
