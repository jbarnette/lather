require "optparse"

module Lather
  class Cli
    def initialize out
      @out = out
      @globs = []
      @verbose = false

      @options = OptionParser.new do |o|
        o.banner = "lather [-hVv] [-r <cmd>] <globs...>" # FIXME
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

    def verbose *args
      @out.puts args.join(" ") if @verbose
    end

    def go! args
      @options.parse!

      @globs.concat args
      exit help! if @globs.empty?

      watcher = Lather::Watcher.new @globs do |file|
        if @command
          out.puts "FIXME: #{@command}"
        else
          out.puts "Changed: #{file}"
        end
      end

      verbose "Watching: #{watcher.files.join(" ")}"
      watcher.go!
    end

    def help!
      @out.puts @options
      1 # process exit code
    end
  end
end
