require "spec_helper"

describe Darstellung::Definable do

  before(:all) do
    class UserResource
      include Darstellung::Representable
      detail :name
      summary :username
    end
  end

  after(:all) do
    Object.__send__(:remove_const, :UserResource)
  end

  let(:resource) do
    UserResource.new(nil)
  end

  describe "#detail_attributes" do

    let(:attributes) do
      resource.detail_attributes
    end

    it "returns the attributes for the detail view" do
      expect(attributes[:name].name).to eq(:name)
    end
  end

  describe "#summary_attributes" do

    let(:attributes) do
      resource.summary_attributes
    end

    it "returns the attributes for the summary view" do
      expect(attributes[:username].name).to eq(:username)
    end
  end
end
