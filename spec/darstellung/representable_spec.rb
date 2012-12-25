require "spec_helper"

describe Darstellung::Representable do

  describe "#collection" do

    before(:all) do
      class User
        attr_reader :name, :country
        def initialize(name, country)
          @name, @country = name, country
        end
      end
    end

    after(:all) do
      Object.__send__(:remove_const, :User)
    end

    context "when the resource has summary definitions" do

      before(:all) do
        class UserResource
          include Darstellung::Representable
          summary :name
          summary :country, from: "1.0.0"
        end
      end

      after(:all) do
        Object.__send__(:remove_const, :UserResource)
      end

      let(:photek) do
        User.new("photek", "USA")
      end

      let(:calyx) do
        User.new("calyx", "UK")
      end

      let(:resource) do
        UserResource.new([ photek, calyx ])
      end

      it "renders the collection of summary representations" do
        expect(resource.collection[:resource]).to eq([
          { name: "photek", country: "USA" },
          { name: "calyx", country: "UK" }
        ])
      end
    end
  end

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

      context "when providing a version" do

        context "when the version is registered" do

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

        context "when the version is not registered" do

          it "raises an error" do
            expect {
              resource.detail("2.1.0")
            }.to raise_error(Darstellung::Registry::NotRegistered)
          end
        end
      end

      context "when no version is provided" do

        let(:representation) do
          resource.detail
        end

        it "returns the name and value of the attribute" do
          expect(representation[:resource]).to eq({ name: "photek" })
        end

        it "defaults the version to none" do
          expect(representation[:version]).to eq("none")
        end
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

  describe "#summary" do

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
          summary :name
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

      context "when providing a version" do

        let(:representation) do
          resource.summary("1.0.0")
        end

        it "returns the name and value of the attribute" do
          expect(representation[:resource]).to eq({ name: "photek" })
        end

        it "returns the requested version" do
          expect(representation[:version]).to eq("1.0.0")
        end
      end

      context "when no version is provided" do

        let(:representation) do
          resource.summary
        end

        it "returns the name and value of the attribute" do
          expect(representation[:resource]).to eq({ name: "photek" })
        end

        it "defaults the version to none" do
          expect(representation[:version]).to eq("none")
        end
      end
    end

    context "when the resource has a versioned definition" do

      before(:all) do
        class UserResource
          include Darstellung::Representable
          summary :name, from: "1.5.0"
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
          resource.summary("1.5.0")
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
          resource.summary("1.0.0")
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
end
