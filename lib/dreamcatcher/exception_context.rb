class Dreamcatcher::ExceptionContext

  attr_reader :exception, :log_entries, :other, :timestamp

  def initialize(exception, log_entries, other = {})
    @exception, @log_entries, @other = exception, log_entries, other
    @timestamp = Time.now
  end
end
