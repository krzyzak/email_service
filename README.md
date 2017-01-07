# EmailService ![CI Status](https://circleci.com/gh/krzyzak/email_service.svg?style=shield&circle-token=:circle-token)

This is a simple service which sends emails. It works as a standalone gem, but it also provides a simple CLI.
Currently, there are two email service providers covered:
 - Mailgun
 - SendGrid

It also contains simple `Fake` provider, which just marks email as sent, without actually sending it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "email_service", github: "krzyzak/email_service"
```

And then execute:

    $ bundle


## Configuration

In order to send emails, you have to configure your providers - `SendGrid` requires `API_KEY` only, whereas `Mailgun` requires `API_KEY`, `API_URL`. You’d probably want to pass `FROM` to configuration file (which will be used instead of `#from` passed by `email` object) too.

All credentials are being stored in the `email_service.yml` file - you can use `email_service.yml.example` as as reference.

You can adjust other settings by calling:

```ruby
EmailService.configuration do |config|
  config.env = "production" # specifies environment. Each environment uses different credentials for providers
  config.max_retries = 10 # Maximum retry count for each provider
  config.retry_formula = ->(n){ n } # Returns how long ruby sleeps between retries for N-th retry
  config.logger = ->(env){ MyCustomLogger.new(env) }
end
```
## Usage

### As a CLI

After you install & configure the application, usage is as easy as
```
bin/email_service send --from="hello@example.com" --to="another@exaple.com" --subject="Sample subject" --text="Hello from my email service!"
```

### As a Gem

After you add a gem as a part of your `Gemfile`, you can create an email:
```ruby
email = EmailService::Email.new({
  from: "hello@example.com",
  to: "another@example.com",
  subject: "Some subject",
  text: "Hello from my email service!",
})
```

then, you should use either of two methods:

`email.send`, or `email.send!` – both method returns an instance of `EmailService::Email`, which responds to `#sent?` and `#error?` methods. The only difference is that the `#send!` method will raise `EmailService::NoMoreProviders` exception, once it will fail on the last provider.


## Testing

You can run test suite by calling `rspec`
