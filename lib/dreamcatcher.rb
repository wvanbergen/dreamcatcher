module Dreamcatcher
  extend self
  
  def monitor(options = {}, &block)
    Dreamcatcher::Monitor.new(configuration).monitor(options, &block)
  end

  def configuration
    @configuration = Dreamcatcher::Configuration.new
  end
end

require "dreamcatcher/version"
require "dreamcatcher/configuration"
require "dreamcatcher/monitor"
require "dreamcatcher/logger_proxy"
require "dreamcatcher/mailer"
