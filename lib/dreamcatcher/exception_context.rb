class Dreamcatcher::ExceptionContext

  attr_reader :exception, :log_entries, :context, :timestamp

  def initialize(exception, log_entries, context = {})
    @exception, @log_entries, @context = exception, log_entries, context
    @timestamp = Time.now
  end

  def [](key)
    @context[key]
  end
end
