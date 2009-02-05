module Lather
  class WatcherTest < Test::Unit::TestCase
    def test_initialize_complains_without_a_callback
      assert_raise ArgumentError do
        Lather::Watcher.new
      end
    end
  end
end
