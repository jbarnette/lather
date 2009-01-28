module Lather
  class Watcher
    attr_reader :files

    def initialize *globs, &callback
      raise ArgumentError, "need a callback" unless block_given?

      @callback = callback
      @files = globs.flatten.collect { |g| Dir[g] }.flatten
    end

    def go!
      puts "FIXME: go!"
    end
  end
end
