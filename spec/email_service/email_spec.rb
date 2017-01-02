require "spec_helper"

describe EmailService::Email do
  let(:invalid_email){ }
  let(:valid_email){ described_class.new }

  describe "basic behaviour" do
    context "new email" do
      it "is not sent by default" do
        expect(subject.sent?).to eq(false)
      end

      it "has empty provider" do
        expect(subject.provider).to eq(nil)
      end
    end

    context "sent email" do
      subject { valid_email }

      before do
        subject.send!(EmailService::Provider::Fake.new)
      end

      it "is marked as sent" do
        expect(subject.sent?).to eq(true)
      end

      it "has provider" do
        expect(subject.provider).to eq(EmailService::Provider::Fake)
      end
    end
  end

  describe "validation" do
    subject { described_class }

    let(:params){ { from: "me@me.com", to: "john@example.com", subject: "Sample subject", text: "Hello!"} }

    it "prevents creating email without 'to' field" do
      data = params.dup
      data.delete(:to)
      expect { subject.new(data) }.to raise_error(Dry::Struct::Error)
    end

    it "prevents creating email without 'from' field" do
      data = params.dup
      data.delete(:from)
      expect { subject.new(data) }.to raise_error(Dry::Struct::Error)
    end

    it "prevents creating email without 'subject' field" do
      data = params.dup
      data.delete(:subject)
      expect { subject.new(data) }.to raise_error(Dry::Struct::Error)
    end

    it "prevents creating email without 'text' field" do
      data = params.dup
      data.delete(:text)

      expect { subject.new(data) }.to raise_error(Dry::Struct::Error)
    end
  end
end
