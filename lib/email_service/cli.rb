require "rainbow"

module EmailService
  class CLI < Thor
    desc "send", "sends email"
    option :from
    option :to, required: true
    option :subject, required: true
    option :text, required: true

    def send
      email = EmailService::Email.new({
        from: options[:from],
        to: options[:to],
        subject: options[:subject],
        text: options[:text],
      }).send

      if email.sent?
        puts Rainbow("Email has been successfully sent").green
      else
        puts Rainbow("There was an error. Email has not been send").red
      end
    end
  end
end
