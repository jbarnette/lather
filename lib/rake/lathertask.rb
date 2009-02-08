require "rake"
require "rake/tasklib"
require "lather/watcher"

module Rake

  # Runs the <tt>target</tt> task any time a file matching one of the
  # <tt>globs</tt> changes.

  class LatherTask < TaskLib

    # An array of globs to watch.

    attr_accessor :globs

    # A hash of options, most of which are passed on to
    # <tt>Lather::Watcher</tt>.

    attr_accessor :options

    # The task to run when things change. Default is
    # <tt>:test</tt>. If this is an instance of
    # <tt>Rake::TestTask</tt>, the task's <tt>file_list</tt> will be
    # added to <tt>globs</tt>, and the <tt>TEST</tt> environment
    # variable will be set to a glob of changed tests before each
    # invocation.

    attr_accessor :target

    def initialize *globs, &block
      @options = Hash === globs.last ? globs.pop : {}
      @globs   = globs
      @target  = @options.delete(:target) || :test

      @changed = case @target
                 when Rake::TestTask then handle_rake_test_task
                 else lambda {}
                 end

      yield self if block_given?

      @target = Rake::Task[@target]

      desc "Rinse and repeat"
      task :lather do
        watcher = Lather::Watcher.new @globs, @options do |changed|
          begin
            @changed[changed]
            @target.invoke
          rescue StandardError => e
            raise e unless e.to_s =~ /^Command failed/
          ensure
            reenable @target
          end
        end

        watcher.go!
      end
    end

    # Get and set the block called each time a file matching one of
    # the <tt>globs</tt> changes. Default is <tt>lambda {}</tt>.

    def changed &block
      return @changed unless block_given?
      @changed = block
    end

    private

    def reenable target
      target.reenable
      target.prerequisites.each { |p| reenable Rake::Task[p] }
    end

    # Special setup when <tt>target</tt> is a <tt>Rake::TestTask</tt>.

    def handle_rake_test_task
      test_task = @target
      all_tests = test_task.file_list

      @target = test_task.name
      @globs << test_task.file_list
      @options[:force] = true

      lambda do |changed|
        tests = all_tests & changed

        basenames = (changed - tests).collect do |f|
          File.basename(f).split(".").first
        end

        tests.concat all_tests.
          select { |t| basenames.any? { |b| t =~ /#{b}/ } }

        tests = all_tests.dup if tests.empty?

        # Nice API, Rake::TestTask.
        ENV["TEST"] = "{#{tests.uniq.join(',')}}"
      end
    end
  end
end
