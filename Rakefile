require "rubygems"
require "./lib/lather"

desc "Run tests."
task :test do
  testify
end

desc "Rinse, repeat."
task :lather do
  Lather::Watcher.new("{lib,test}/**/*.rb") { testify }.go!
end

def testify
  puts `ruby -Ilib:test #{Dir['test/**/*_test.rb'].join(' ')}`
end

task :default => :test
