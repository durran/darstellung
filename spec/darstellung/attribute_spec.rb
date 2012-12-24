require "spec_helper"

describe Darstellung::Attribute do

  describe "#displayable?" do

    context "when no from option exists" do

      let(:attribute) do
        described_class.new(:name)
      end

      it "returns true" do
        expect(attribute).to be_displayable("1.0.0")
      end
    end

    context "when a from option exists" do

      let(:attribute) do
        described_class.new(:name, from: "1.0.0")
      end

      context "when the version is lower" do

        it "returns false" do
          expect(attribute).to_not be_displayable("0.9.0")
        end
      end

      context "when the version is equal" do

        it "returns true" do
          expect(attribute).to be_displayable("1.0.0")
        end
      end

      context "when the version is higher" do

        it "returns true" do
          expect(attribute).to be_displayable("1.0.1")
        end
      end
    end

    context "when a to option exists" do

      let(:attribute) do
        described_class.new(:name, to: "1.0.0")
      end

      context "when the version is lower" do

        it "returns true" do
          expect(attribute).to be_displayable("0.9.0")
        end
      end

      context "when the version is equal" do

        it "returns true" do
          expect(attribute).to be_displayable("1.0.0")
        end
      end

      context "when the version is higher" do

        it "returns false" do
          expect(attribute).to_not be_displayable("1.0.1")
        end
      end
    end

    context "when both a from and to option exist" do

      let(:attribute) do
        described_class.new(:name, from: "0.9.0", to: "1.0.0")
      end

      context "when the version is in the range" do

        it "returns true" do
          expect(attribute).to be_displayable("0.9.5")
        end
      end

      context "when the version is equal to the from" do

        it "returns true" do
          expect(attribute).to be_displayable("0.9.0")
        end
      end

      context "when the version is equal to the to" do

        it "returns true" do
          expect(attribute).to be_displayable("1.0.0")
        end
      end

      context "when the version is out of range" do

        it "returns false" do
          expect(attribute).to_not be_displayable("1.0.5")
        end
      end
    end
  end

  describe "#initialize" do

    let(:attribute) do
      described_class.new(:name, from: "0.0.0")
    end

    it "sets the attribute name" do
      expect(attribute.name).to eq(:name)
    end

    it "sets the options" do
      expect(attribute.options).to eq(from: "0.0.0")
    end
  end

  describe "#value" do

    before(:all) do
      class User
        attr_reader :name
        def initialize(name)
          @name = name
        end
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
    end

    let(:user) do
      User.new("photek")
    end

    context "when no block was provided" do

      let(:attribute) do
        described_class.new(:name)
      end

      let(:value) do
        attribute.value(user)
      end

      it "sends the method to the resource" do

      end
    end

    context "when a block was provided" do

      it "yields to the resource" do

      end
    end
  end
end
