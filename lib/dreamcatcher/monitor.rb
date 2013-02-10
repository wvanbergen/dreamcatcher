class Dreamcatcher::Monitor

  attr_reader :configuration, :handlers

  def initialize(configuration)
    @configuration = configuration
    @handlers = build_handlers
  end

  def monitor(options = {}, &block)
    @context = options[:context] || {}
    logger_proxy = Dreamcatcher::LoggerProxy.new(options[:logger])
    logger_proxy.capture { block.call }
      
  rescue @configuration.exception_class => exception
    context = Dreamcatcher::ExceptionContext.new(exception, logger_proxy.log_entries)
    handlers.each { |handler| handler.handle_exception(context) }
    raise 
  end

  protected 

  def build_handlers
    mailer = Dreamcatcher::Mailer.new(configuration.mailer)
    [mailer]
  end
end
