require "spec_helper"

describe Darstellung::Representable do

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

    context "when the resource has a standard definition" do

      before(:all) do
        class UserResource
          include Darstellung::Representable
          detail :name
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:user) do
        User.new("photek")
      end

      let(:resource) do
        UserResource.new(user)
      end

      let(:representation) do
        resource.detail("1.0.0")
      end

      it "returns the name and value of the attribute" do
        expect(representation[:resource]).to eq({ name: "photek" })
      end

      it "returns the requested version" do
        expect(representation[:version]).to eq("1.0.0")
      end
    end

    context "when the resource has a versioned definition" do

      before(:all) do
        class UserResource
          include Darstellung::Representable
          detail :name, from: "1.5.0"
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:user) do
        User.new("photek")
      end

      let(:resource) do
        UserResource.new(user)
      end

      context "when asking for a valid version" do

        let(:representation) do
          resource.detail("1.5.0")
        end

        it "returns the name and value of the attribute" do
          expect(representation[:resource]).to eq({ name: "photek" })
        end

        it "returns the requested version" do
          expect(representation[:version]).to eq("1.5.0")
        end
      end

      context "when asking for a version out of range" do

        let(:representation) do
          resource.detail("1.0.0")
        end

        it "does not contain the attribute" do
          expect(representation[:resource]).to be_empty
        end

        it "returns the requested version" do
          expect(representation[:version]).to eq("1.0.0")
        end
      end
    end
  end

  describe "#initialize" do

    before(:all) do
      class User; end
      class UserResource
        include Darstellung::Representable
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
      Object.__send__(:remove_const, :UserResource)
    end

    context "when provided a single object" do

      let(:user) do
        User.new
      end

      let(:resource) do
        UserResource.new(user)
      end

      it "sets the object as the resource" do
        expect(resource.resource).to eq(user)
      end
    end

    context "when provided an enumerable of objects" do

      let(:user) do
        User.new
      end

      let(:resource) do
        UserResource.new([ user ])
      end

      it "sets the object as the resource" do
        expect(resource.resource).to eq([ user ])
      end
    end
  end
end
