require "minitest/autorun"
require "lather/cli"

module Lather
  class CliTest < MiniTest::Unit::TestCase
    def setup
      @cli = Lather::Cli.new
      def @cli.exit *args; throw :exit end
    end

    def parse! *args
      capture_io do
        catch(:exit) { @cli.parse! args }
      end
    end

    def test_empty_invocation_prints_help
      out, err = parse!
      assert_match(/Shows help/, out)
    end

    def test_V_option_prints_version
      %w(-V --version).each do |flag|
        out, err = parse! flag
        assert_equal Lather::VERSION, out.chomp
      end
    end
  end
end
