require 'test_helper'
require 'logger'

class LoggerProxyTest < Test::Unit::TestCase

  def test_logger_capture
    logger = Logger.new("/dev/null")
    proxy = Dreamcatcher::LoggerProxy.new(logger)
    proxy.capture do
      logger.info "hello world"
    end
    logger.info "goodbye world"

    assert_equal proxy.log_entries.size, 1
    assert_equal proxy.log_entries.first.message, "hello world"
  end
end
