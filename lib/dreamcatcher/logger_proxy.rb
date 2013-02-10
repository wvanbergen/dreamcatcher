require 'logger'

class Dreamcatcher::LoggerProxy

  attr_reader :original_logger, :log_entries

  def initialize(logger)
    @original_logger = logger
    @log_entries = []
  end

  def capture(&block)
    register_logger_monkeypatch unless @original_logger.nil?
    yield if block_given?
    return self
  ensure
    deregister_logger_monkeypatch unless @original_logger.nil?
  end

  def self.capture(logger, &block)
    Dreamcatcher::LoggerProxy.new(logger).capture(&block)
  end

  protected

  def register_logger_monkeypatch
    @original_logger.instance_variable_set(:"@_captured_entries", @log_entries)
    class << @original_logger
      def add_with_capture(severity, prog, message = nil, &block)
        message = yield if message.nil? && block_given?
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

    def to_s(format = '%t [%s] %m')
      format.
        sub('%s', format_severity).
        sub('%m', @message || '').
        sub('%p', @prog || '').
        sub('%t', format_timestamp)
    end

    protected

    # Severity label for logging (max 5 chars).
    SEV_LABEL = %w(DEBUG INFO WARN ERROR FATAL ANY)

    def format_severity
      SEV_LABEL[severity] || 'ANY'
    end

    def format_timestamp
      timestamp.strftime('%F %T %Z')
    end
  end
end
