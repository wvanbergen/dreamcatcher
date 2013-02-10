class Dreamcatcher::Configuration

  attr_accessor :exception_class

  def initialize
    @exception_class = StandardError
  end
end
