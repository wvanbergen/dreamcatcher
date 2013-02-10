class Dreamcatcher::Configuration

  attr_accessor :exception_class, 
                :to, :from, :subject, 
                :deliver, :via, :via_options, 
                :template, :template_dir

  def initialize
    @exception_class = StandardError
    @from = 'exceptions@example.com'
    @subject = lambda do |context|
      "Exception #{context.exception.class.name}: #{context.exception.message}"
    end

    @template_dir = Dreamcatcher::TEMPLATE_DIR
    @template     = 'generic_exception'
    
    @via          = :sendmail
    @via_options  = nil
    @deliver      = false
  end

  def evaluate(symbol, *args)
    value = self.send(symbol)
    value.respond_to?(:call) ? value.call(*args) : value
  end
end
