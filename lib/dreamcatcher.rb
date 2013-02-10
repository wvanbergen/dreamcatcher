require "dreamcatcher/version"

module Dreamcatcher
  extend self
  
  def monitor(options = {}, &block)
    context = options[:context] || {}
    log_entries = DreamCatcher::LoggerProxy.capture(options[:logger]) do
      block.call
    end

  rescue Exception => exception
    # send email
    raise
  end
end

require "dreamcatcher/logger_proxy"
