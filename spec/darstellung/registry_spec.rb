require "spec_helper"

describe Darstellung::Registry do

  describe ".register" do

    context "when a from version exists" do

      before do
        described_class.register(from: "1.0.0")
      end

      after do
        described_class.__send__(:registered_versions).clear
      end

      it "registers the version" do
        expect(described_class).to be_registered("1.0.0")
      end
    end

    context "when a to version exists" do

      before do
        described_class.register(to: "1.0.5")
      end

      after do
        described_class.__send__(:registered_versions).clear
      end

      it "registers the version" do
        expect(described_class).to be_registered("1.0.5")
      end
    end

    context "when no version information exists" do

      before do
        described_class.register({})
      end

      it "does not register anything" do
        expect(described_class.__send__(:registered_versions)).to be_empty
      end
    end
  end
end
