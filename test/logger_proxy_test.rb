require 'test_helper'
require 'logger'

class LoggerProxyTest < Test::Unit::TestCase

  def test_logger_capture
    logger = Logger.new("/dev/null")
    proxy = Dreamcatcher::LoggerProxy.capture(logger) do
      logger.info "hello world"
    end
    logger.info "goodbye world"

    assert_equal proxy.log_entries.size, 1
    assert_equal proxy.log_entries.first.message, "hello world"
  end

  def test_capture_without_logger
    logger = Logger.new("/dev/null")
    proxy = Dreamcatcher::LoggerProxy.capture(nil) do
      logger.info "hello world"
    end
    assert_equal proxy.log_entries.size, 0
  end
end
