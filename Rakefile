require "rubygems"
require "rubygems/specification"

require "./lib/lather"

namespace :gem do
  desc "Update the gemspec."
  task :spec do
    spec = Gem::Specification.new do |s|
      s.name         = "lather"
      s.version      = Lather::VERSION
      s.platform     = Gem::Platform::RUBY
      s.has_rdoc     = false
      s.summary      = "Lather rinses and repeats."
      s.description  = s.summary
      s.author       = "John Barnette"
      s.email        = "jbarnette@gmail.com"
      s.homepage     = "http://github.com/jbarnette/lather"
      s.require_path = "lib"
      s.bindir       = "bin"
      s.executables  = %w(lather)

      s.files = %w(Rakefile README.markdown) + Dir["{bin,lib,test}/**/*"]
    end

    File.open("#{spec.name}.gemspec", "w") do |f|
      f.puts spec.to_ruby
    end
  end
end

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
