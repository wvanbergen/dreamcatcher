class Dreamcatcher::Configuration

  class Mailer
    attr_accessor :to, :from, :subject, :deliver, :via, :via_options, :template, :template_dir

    def initialize
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
  end

  attr_accessor :exception_class, :mailer

  def initialize
    @exception_class = StandardError
    @mailer = Dreamcatcher::Configuration::Mailer.new
  end
end
