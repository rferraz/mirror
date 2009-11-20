#!/usr/bin/env ruby

require "rake"
require "rake/testtask"

desc "Run test suite"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

task :default => ["test"]
