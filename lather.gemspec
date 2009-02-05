# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{lather}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Barnette"]
  s.date = %q{2009-02-05}
  s.default_executable = %q{lather}
  s.description = %q{Lather rinses and repeats.}
  s.email = %q{jbarnette@gmail.com}
  s.executables = ["lather"]
  s.files = ["Rakefile", "README.markdown", "bin/lather", "lib/lather", "lib/lather/cli.rb", "lib/lather/version.rb", "lib/lather/watcher.rb", "lib/lather.rb", "lib/rake", "lib/rake/lathertask.rb", "test/helper.rb", "test/lather", "test/lather/cli_test.rb", "test/lather/watcher_test.rb"]
  s.homepage = %q{http://github.com/jbarnette/lather}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Lather rinses and repeats.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
