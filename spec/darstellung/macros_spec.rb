require "spec_helper"

describe Darstellung::Macros do

  describe "#detail" do

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

    context "when providing only an attribute name" do

      before(:all) do
        class UserResource
          include Darstellung::Representable
          detail :name
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:field) do
        UserResource.detail_attributes[:name]
      end

      it "creates a detail attribute field" do
        expect(field).to be_a(Darstellung::Attribute)
      end

      it "sets the name of the field" do
        expect(field.name).to eq(:name)
      end
    end

    context "when providing a version" do

    end

    context "when providing a block" do

    end
  end

  describe "#summary" do

  end
end
