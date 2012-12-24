# encoding: utf-8
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
