require 'test_helper'
require 'logger'

Dreamcatcher.configuration.to = 'example@example.com'
Dreamcatcher.configuration.deliver = false

class DreamcatcherTest < Test::Unit::TestCase

  def test_monitor_should_reraise_exception
    assert_raises(RuntimeError) do
      Dreamcatcher.monitor do
        raise "error"
      end
    end
  end
end
