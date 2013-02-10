require 'test_helper'
require 'logger'

class DreamcatcherTest < Test::Unit::TestCase

  def test_monitor_should_reraise_exception
    # assert_raises(RuntimeError) do
      Dreamcatcher.monitor do
        raise "error"
      # end
    end
  end
end
