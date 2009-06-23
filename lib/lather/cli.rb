require "optparse"

require "lather"

module Lather
  class Cli
    def initialize
      @command = nil
      @globs = []
      @verbose = false

      @options = OptionParser.new do |o|
        o.banner = "#$0 [-hVv] [-r <cmd>] <globs...>"
        o.separator ""

        o.on "--help", "-h", "-?", "Shows help." do
          exit help!
        end

        o.on "--verbose", "-v", "Talks your ear off." do
          @verbose = true
        end

        o.on "--version", "-V", "Prints #{Lather::VERSION}." do
          puts Lather::VERSION
          exit
        end

        o.on "--rinse [cmd]", "--run", "-r", "Runs when things change." do |cmd|
          @command = cmd
        end

        o.separator ""
      end
    end

    def parse! args
      @options.parse! args
      @globs.concat args
      exit help! if @globs.empty?
    end

    def go! args
      parse! args

      watcher = Lather::Watcher.new @globs do |files|
        if @command
          system @command
        else
          puts "Changed: #{files.join(" ")}"
        end
      end

      verbose "Watching: #{watcher.files.keys.sort.join(" ")}"
      watcher.go!
    end

    private

    def verbose *args
      puts args.join(" ") if @verbose
    end

    def help!
      puts @options
      1 # process exit code
    end
  end
end
