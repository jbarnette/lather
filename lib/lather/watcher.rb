module Lather
  class Watcher
    attr_reader :files
    attr_reader :options

    def initialize *globs, &callback
      raise ArgumentError, "need a callback" unless block_given?
      @callback = callback

      @options = { :force => false, :sleep => 1 }
      @options.merge!(globs.pop) if globs.last.is_a? Hash

      @globs = globs.flatten
      @files = find_files
    end

    def go!
      @timestamp = Time.now

      @callback[@files.keys] if @options[:force]

      loop do
        unless (changed = update_files_and_timestamp).empty?
          @callback[changed]
        end

        Kernel.sleep @options[:sleep]
      end
    end

    private

    def update_files_and_timestamp
      @files = find_files
      updated = @files.keys.select { |k| @files[k] > @timestamp }
      @timestamp = @files.values.max

      updated
    end

    def find_files
      files = {}

      @globs.collect { |g| Dir[g] }.flatten.each do |file|
        # silently skip stat failures: file deleted, etc.
        files[file] = File.stat(file).mtime rescue next
      end

      files
    end
  end
end
