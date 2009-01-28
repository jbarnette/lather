module Lather
  class Watcher
    attr_reader :files

    def initialize *globs, &callback
      raise ArgumentError, "need a callback" unless block_given?
      @callback = callback

      @options = { :sleep => 1 }
      @options.merge!(globs.pop) if globs.last.is_a? Hash

      @globs = globs
      @files = find_files
    end

    def go!
      loop do
        unless (changed = get_changed_files).empty?
          @callback[changed]
        end

        Kernel.sleep @options[:sleep]
      end
    end

    private

    def get_changed_files
      ["FIXME"]
    end

    def find_files
      files = {}

      @globs.flatten.collect { |g| Dir[g] }.flatten.each do |file|
        files[file] = File.stat(file).mtime rescue next
      end

      files
    end
  end
end
