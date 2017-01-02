require "spec_helper"

describe EmailService::Email do
  let(:invalid_email){ }
  let(:valid_email){ described_class.new }

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
