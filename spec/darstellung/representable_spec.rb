require "spec_helper"

describe Darstellung::Representable do

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
