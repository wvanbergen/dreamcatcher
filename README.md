# Dreamcatcher

A simple gem to catch exceptions and send email notifications.

This gem is especially made for monitoring tasks, like rake tasks or background jobs.
It can also capture messages you send to a logger during the monitored code, and
include the log snippet in the notification. 

## Installation

Add this line to your application's Gemfile:

    gem 'dreamcatcher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dreamcatcher

## Usage

Use `Dreamcatcher.monitor` to monitor a block of code for exceptions

    logger = Logger.new($stdout)
    Dreamcatcher.monitor(logger: logger) do
      logger.debug "progress"
      raise 'omg ponies'
    end

If Dreamcatcher catches an exception, it will send an email, and re-raise the exception. 

You can configure Dreamcatcher using the `configuration` object.
You can provide a static value or a block that will be dynamically evaluated
when the value is needed.

    Dreamcatcher.configuration.from = 'willem@example.com'
    Dreamcatcher.configuration.to   = 'willem+exceptions@example.com'
    Dreamcatcher.configuration.subject = lambda do |context|
      "[My app] #{context.exception.class.name}: #{context.exception.message}"
    end

    # This defines whether the email will actually be delivered.
    Dreamcatcher.configuration.subject.deliver = lambda { RACK_ENV == 'production' }

    # Dreamcatcher uses the pony gem to send emails: https://github.com/benprew/pony
    # The following options are copied directly to `Pony.mail`

    Dreamcatcher.configuration.via = :smtp
    Dreamcatcher.configuration.via_options = { ... }

    # You can specify what templates to use for the emails.
    # Dreamcatcher ships with basic templates, so you can leave these options blank.
    # It will look for `#{template_dir}/#{template}.html.erb` for the HTML part
    # and `#{template_dir}/#{template}.text.erb` for the plain text part of the email.
    
    Dreamcatcher.configuration.template_dir = "./email_templates"
    Dreamcatcher.configuration.template = lambda do |context|
      # Use a custom template for a particular exception
      if context.exception.class == MyAwesomeException
        'my_awesome_exception'
      else
        'generic_exception'
      end
    end



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature -u`)
5. Create new Pull Request
