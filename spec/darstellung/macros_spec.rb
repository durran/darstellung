require "spec_helper"

describe Darstellung::Macros do

  describe "#detail" do

    before(:all) do
      class User
        attr_reader :name
        def initialize(name)
          @name = name
        end
        def long_name
          "#{name}+"
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

      before(:all) do
        class UserResource
          include Darstellung::Representable
          detail :name, from: "1.0.0"
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:field) do
        UserResource.detail_attributes[:name]
      end

      it "allows the field to be displayable by version" do
        expect(field).to be_displayable("1.0.1")
      end
    end

    context "when providing a block" do

      before(:all) do
        class UserResource
          include Darstellung::Representable
          detail :name do |user|
            user.long_name
          end
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:user) do
        User.new("photek")
      end

      let(:field) do
        UserResource.detail_attributes[:name]
      end

      it "allows using the block to get the field value" do
        expect(field.value(user)).to eq("photek+")
      end
    end
  end

  describe "#summary" do

    before(:all) do
      class User
        attr_reader :name
        def initialize(name)
          @name = name
        end
        def long_name
          "#{name}+"
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
          summary :name
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:field) do
        UserResource.summary_attributes[:name]
      end

      it "creates a summary attribute field" do
        expect(field).to be_a(Darstellung::Attribute)
      end

      it "sets the name of the field" do
        expect(field.name).to eq(:name)
      end
    end

    context "when providing a version" do

      before(:all) do
        class UserResource
          include Darstellung::Representable
          summary :name, from: "1.0.0"
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:field) do
        UserResource.summary_attributes[:name]
      end

      it "allows the field to be displayable by version" do
        expect(field).to be_displayable("1.0.1")
      end
    end

    context "when providing a block" do

      before(:all) do
        class UserResource
          include Darstellung::Representable
          summary :name do |user|
            user.long_name
          end
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:user) do
        User.new("photek")
      end

      let(:field) do
        UserResource.summary_attributes[:name]
      end

      it "allows using the block to get the field value" do
        expect(field.value(user)).to eq("photek+")
      end
    end
  end
end
