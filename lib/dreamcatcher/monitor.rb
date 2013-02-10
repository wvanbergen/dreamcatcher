class Dreamcatcher::Monitor

  attr_reader :configuration, :context

  def initialize(configuration)
    @configuration = configuration
  end

  def monitor(options = {}, &block)
    @context = options[:context] || {}
    log_entries = Dreamcatcher::LoggerProxy.capture(options[:logger]) do
      block.call
    end

  rescue @configuration.exception_class => exception
    # handle exception
    raise
  end
end
