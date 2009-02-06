require "rake"
require "rake/tasklib"
require "lather/watcher"

module Rake

  # A simplified version of <tt>Rake::TestTask</tt> with support for
  # Lather. It creates <tt>test</tt> and <tt>test:lather</tt>
  # tasks. It's more opinionated and less configurable than
  # <tt>Rake::TestTask</tt>: Test file load order is random.
  #
  # When lathering, a very stupid heuristic is used to decide which
  # test files to run: Any test file whose path contains the basename
  # (without extension) of the file that changed. If no test files
  # match, everything gets run. No tracking of failures, no specific
  # tests. If you want more than this, you should be using Autotest.

  class LatherTestTask < TaskLib

    # An optional array of stuff to tack on to the end of the Ruby
    # command-line. Default is <tt>[]</tt>.

    attr_accessor :extras

    # An array of glob patterns to match implementation files. Default
    # is <tt>%w(lib/**/*.rb)</tt>.

    attr_accessor :files

    # An array of command-line flags to pass on to Ruby. Default is
    # <tt>%w(-w)</tt>.

    attr_accessor :flags

    # An array of directories to add to the load path. Default is
    # <tt>%w(lib test)</tt>.

    attr_accessor :libs

    # A hash of options to pass on to <tt>Lather::Watcher.new</tt>.
    # Default is <tt>{ :force => true }</tt>.

    attr_accessor :options

    # An array of glob patterns to match test files. Default is
    # <tt>%w(test/**/*_test.rb)</tt>.

    attr_accessor :tests

    # Be chatty? Default is <tt>false</tt>.

    attr_accessor :verbose

    def initialize
      @extras  = []
      @files   = %w(lib/**/*.rb)
      @flags   = %w(-w)
      @libs    = %w(lib test)
      @options = { :force => true }
      @tests   = %w(test/**/*_test.rb)
      @verbose = false

      yield self if block_given?

      desc "Run the tests"
      task(:test) { testify FileList[@tests] }

      namespace :test do

        desc "Test, rinse, repeat"
        task :lather do
          watcher = Lather::Watcher.new @files, @tests, @options do |changed|
            all_tests = FileList[@tests]
            tests = all_tests & changed

            basenames = (changed - tests).collect do |f|
              File.basename(f).split(".").first
            end
            
            tests.concat all_tests.
              select { |t| basenames.any? { |b| t =~ /#{b}/ } }

            begin
              testify tests.empty? ? all_tests : tests.uniq
            rescue StandardError => e
              raise e unless e.to_s =~ /^Command failed/
            end
          end

          watcher.go!
        end
      end
    end

    private

    def testify tests
      cmd = @flags.dup
      cmd << "-I#{@libs.join(':')}"
      cmd << "-e 'ARGV.each { |f| load f }'"
      
      cmd.concat tests.collect { |f| "'#{f}'" }.sort_by { rand }
      cmd.concat @extras

      RakeFileUtils.verbose(@verbose) { ruby cmd.join(" ") }
    end
  end
end
