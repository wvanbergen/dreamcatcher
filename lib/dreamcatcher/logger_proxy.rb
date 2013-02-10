class Dreamcatcher::LoggerProxy

  attr_reader :original_logger, :log_entries

  def initialize(logger)
    @original_logger = logger
    @log_entries = []
  end

  def capture(&block)
    register_logger_monkeypatch
    yield
    log_entries
  ensure
    deregister_logger_monkeypatch
  end

  def self.capture(logger, &block)
    if logger.nil?
      block.call()
      return []
    else
      new(logger).capture(&block)
    end
  end

  protected

  def register_logger_monkeypatch
    @original_logger.instance_variable_set(:"@_captured_entries", @log_entries)
    class << @original_logger
      def add_with_capture(severity, prog, message)
        @_captured_entries << LogEntry.new(severity, prog, message)
        add_without_capture(severity, prog, message)
      end
      alias_method :add_without_capture, :add
      alias_method :add, :add_with_capture
    end
  end

  def deregister_logger_monkeypatch
    class << @original_logger
      alias_method :add, :add_without_capture
      undef_method :add_without_capture
      undef_method :add_with_capture
    end
    @original_logger.send :remove_instance_variable, :"@_captured_entries"
  end  

  class LogEntry
    attr_reader :severity, :message, :timestamp

    def initialize(severity, prog, message, timestamp = nil)
      @severity  = severity
      @prog      = prog
      @message   = message
      @timestamp = timestamp || Time.now
    end
  end
end