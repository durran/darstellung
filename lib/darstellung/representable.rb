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

    # Gets the detail view for a specific version of the resource. If no
    # version is provided then we assume from "0.0.0" which will render
    # attributes available in all versions of the API.
    #
    # @example Get the detail representation.
    #   user_resource.detail("1.0.1")
    #
    # @param [ String ] requested_version The version to get of the resource.
    #
    # @return [ Hash ] The detail representation of the resource.
    #
    # @since 0.0.0
    def detail(requested_version = nil)
      version = requested_version || "0.0.0"
      { version: version, resource: single(detail_attributes, version) }
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
    # @param [ String ] requested_version The version to get of the resource.
    #
    # @return [ Hash ] The summary representation of the resource.
    #
    # @since 0.0.0
    def summary(requested_version = nil)
      version = requested_version || "0.0.0"
      { version: version, resource: single(summary_attributes, version) }
    end

    private

    def detail_attributes
      self.class.detail_attributes
    end

    def single(attributes, version, representation = {})
      attributes.each do |name, attribute|
        if attribute.displayable?(version)
          representation[name] = attribute.value(resource)
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
