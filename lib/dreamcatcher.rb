module Dreamcatcher
  extend self
  
  def monitor(options = {}, &block)
    Dreamcatcher::Monitor.new(configuration).monitor(options, &block)
  end

  def configuration
    @configuration = Dreamcatcher::Configuration.new
  end

  TEMPLATE_DIR = File.expand_path('../dreamcatcher/templates', __FILE__)
end

require "dreamcatcher/version"
require "dreamcatcher/configuration"
require "dreamcatcher/monitor"
require "dreamcatcher/exception_context"
require "dreamcatcher/logger_proxy"
require "dreamcatcher/mailer"
