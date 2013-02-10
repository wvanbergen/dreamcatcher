class Dreamcatcher::ExceptionContext

  attr_reader :exception, :log_entries, :other

  def initialize(exception, log_entries, other = {})
    @exception, @log_entries, @other = exception, log_entries, other
  end
end