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
    if configuration.evaluate(:deliver, context)
      Pony.mail(email_options)
    else
      # TODO: print / log email somewhere
    end
  end

  def build_email_options(context)

    options = {
      :to          => configuration.evaluate(:to, context),
      :from        => configuration.evaluate(:from, context),
      :subject     => configuration.evaluate(:subject, context),
      :via         => configuration.evaluate(:via, context),
      :via_options => configuration.evaluate(:via_options, context)
    }

    options[:body]      = render_body(:text, context, options)
    options[:html_body] = render_body(:html, context, options)

    options.delete_if { |k, v| v.nil? }
    raise "E-mail has no to recipient!" unless options[:to]
    raise "E-mail has no body!" unless options[:body] || options[:html_body]

    options
  end

  def render_body(type, context, options)
    template_dir  = configuration.evaluate(:template_dir, context)
    template      = configuration.evaluate(:template, context)
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
    ERB.new(File.read(template_file), nil, '<>').result(context.get_binding(&block))
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
