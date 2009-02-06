require "rubygems/specification"
require "rake/testtask"

require "./lib/lather"
require "./lib/rake/lathertesttask"

namespace :gem do
  LATHER = Gem::Specification.new do |s|
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

  gemspec = file "#{LATHER.name}.gemspec" => LATHER.files do |file|
    File.open(file.name, "w") do |f|
      f.puts LATHER.to_ruby
    end
  end

  gemfile = file "#{LATHER.name}-#{LATHER.version}.gem" => gemspec do |file|
    sh "gem build #{file.prerequisites.first}"
  end

  desc "Build and install the gem"
  task :install => gemfile do
    sh "sudo gem install #{LATHER.name}-#{LATHER.version}.gem"
  end
end

Rake::LatherTestTask.new do |test|
  test.flags << "-rhelper"
end

task :default => :test
