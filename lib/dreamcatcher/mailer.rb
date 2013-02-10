require "delegate"
require "pony"
require "erb"

class Dreamcatcher::Mailer

  attr_reader :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  def handle_exception(context)
    email_options = build_email_options(context)
    if evaluate_config_option(:deliver, context)
      Pony.mail(email_options)
    else
      p email_options
    end
  end

  def evaluate_config_option(symbol, context)
    value = configuration.send(symbol)
    value.respond_to?(:call) ? value.call(context) : value
  end

  def build_email_options(context)

    options = {
      :to          => evaluate_config_option(:to, context),
      :from        => evaluate_config_option(:from, context),
      :subject     => evaluate_config_option(:subject, context),
      :via         => evaluate_config_option(:via, context),
      :via_options => evaluate_config_option(:via_options, context)
    }

    options[:body]      = render_body(:text, context, options)
    options[:html_body] = render_body(:html, context, options)

    options.delete_if { |k, v| v.nil? }
    raise "E-mail has no to recipient!" unless options[:to]
    raise "E-mail has no body!" unless options[:body] || options[:html_body]

    options
  end

  def render_body(type, context, options)
    template_dir  = evaluate_config_option(:template_dir, context)
    template      = evaluate_config_option(:template, context)
    template_file = erb_template_file(template_dir, template, type)
    email_context = EmailContext.new(context, options)

    if File.exists?(template_file)
      layout_file = erb_template_file(template_dir, 'layout', type)
      if File.exists?(layout_file)
        render_erb_template(layout_file, email_context) do
          render_erb_template(template_file, email_context) 
        end
      else
        render_erb_template(template_file, email_context) 
      end
    else
      nil
    end
  end

  def render_erb_template(template_file, context, &block)
    ERB.new(File.read(template_file)).result(context.get_binding(&block))
  end

  def erb_template_file(dir, name, type)
    File.join(dir, "#{name}.#{type}.erb")
  end


  class EmailContext < SimpleDelegator
    def initialize(context, options)
      super(context)
      @context, @options = context, options
    end

    def subject
      @options[:subject]
    end

    def to
      @options[:to]
    end

    def cc
      @options[:cc]
    end

    def bcc
      @options[:bcc]
    end

    def from
      @options[:from]
    end

    def get_binding
      binding
    end
  end
end
