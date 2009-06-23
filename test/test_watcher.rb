require "minitest/autorun"
require "lather/watcher"

module Lather
  class WatcherTest < MiniTest::Unit::TestCase
    def test_initialize_complains_without_a_callback
      assert_raises ArgumentError do
        Lather::Watcher.new
      end
    end
  end
end
