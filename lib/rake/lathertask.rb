require "rake"
require "rake/tasklib"
require "lather/watcher"

module Rake
  class LatherTask < TaskLib
    attr_accessor :globs, :target

    def initialize *globs, &block
      @target = :test
      @globs = globs 

      yield self if block_given?

      desc "Rinse and repeat"
      Rake::Task.define_task :lather do
        watcher = Lather::Watcher.new @globs do
          target = Rake::Task[@target]

          begin
            target.invoke
          rescue StandardError => e
            raise e unless e.to_s =~ /^Command failed/
          ensure
            target.reenable
          end
        end

        watcher.go!
      end
    end
  end
end
