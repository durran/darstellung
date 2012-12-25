# encoding: utf-8
require "darstellung/attribute"
require "darstellung/macros"

module Darstellung

  # This module is included into resources that need a summary and detail view
  # for display in APIs. Summary views are for display in lists, detail views
  # are generally show actions.
  #
  # @since 0.0.0
  module Representable

    # @attribute [r] resource The resource being represented.
    attr_reader :resource

    # Gets the collection view for a specific version of the resource. If no
    # version is provided then we assume from "0.0.0" which will render
    # attributes available in all versions of the API.
    #
    # @example Get the collection representation.
    #   user_resource.collection("1.0.1")
    #
    # @note The collection representation is a list of summary representations.
    #
    # @param [ String ] version The version to get of the resource.
    #
    # @return [ Hash ] The collection representation of the resource.
    #
    # @since 0.0.0
    def collection(version = nil)
      representation(version, multiple(summary_attributes, version))
    end

    # Gets the detail view for a specific version of the resource. If no
    # version is provided then we assume from "0.0.0" which will render
    # attributes available in all versions of the API.
    #
    # @example Get the detail representation.
    #   user_resource.detail("1.0.1")
    #
    # @param [ String ] version The version to get of the resource.
    #
    # @return [ Hash ] The detail representation of the resource.
    #
    # @since 0.0.0
    def detail(version = nil)
      representation(version, single(detail_attributes, resource, version))
    end

    # Initialize the new representation with the provided resource.
    #
    # @example Initialize the representation.
    #   class UserResource
    #     include Darstellung::Representable
    #   end
    #
    #   UserResource.new(user)
    #
    # @param [ Object ] resource The resource to be represented.
    #
    # @since 0.0.0
    def initialize(resource)
      @resource = resource
    end

    # Gets the summary view for a specific version of the resource. If no
    # version is provided then we assume from "0.0.0" which will render
    # attributes available in all versions of the API.
    #
    # @example Get the summary representation.
    #   user_resource.summary("1.0.1")
    #
    # @param [ String ] version The version to get of the resource.
    #
    # @return [ Hash ] The summary representation of the resource.
    #
    # @since 0.0.0
    def summary(version = nil)
      representation(version, single(summary_attributes, resource, version))
    end

    private

    def detail_attributes
      self.class.detail_attributes
    end

    def representation(version, resource)
      { version: version || "none", resource: resource }
    end

    def multiple(attributes, version, representation = [])
      resource.each do |object|
        representation.push(single(attributes, object, version))
      end
      representation
    end

    def single(attributes, object, version, representation = {})
      attributes.each do |name, attribute|
        if attribute.displayable?(version)
          representation[name] = attribute.value(object)
        end
      end
      representation
    end

    def summary_attributes
      self.class.summary_attributes
    end

    class << self

      # Including the module will inject the necessary macros into the base
      # class.
      #
      # @exampe Include the Representable module.
      #   class UserResource
      #     include Darstellung::Representable
      #   end
      #
      # @param [ Class ] klass The class including the module.
      #
      # @since 0.0.0
      def included(klass)
        klass.extend(Macros)
      end
    end
  end
end
