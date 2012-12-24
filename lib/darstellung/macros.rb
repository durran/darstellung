# encoding: utf-8
module Darstellung

  # This module provides all the class level macros for defining
  # representations.
  #
  # @since 0.0.0
  module Macros

    # Defines an attribute to be displayed in the detail representation of the
    # resource.
    #
    # @example Display the name field in the detail display.
    #   class UserResource
    #     include Darstellung::Representable
    #     detail :name
    #   end
    #
    # @example Display the name field only from version 1.0.0
    #   class UserResource
    #     include Darstellung::Representable
    #     detail :name, from: "1.0.0"
    #   end
    #
    # @example Display the name field only from version 1.0.0 - 1.1.0
    #   class UserResource
    #     include Darstellung::Representable
    #     detail :name, from: "1.0.0", to: "1.1.0"
    #   end
    #
    # @example Display the name field as a custom representation.
    #   class UserResource
    #     include Darstellung::Representable
    #
    #     detail :name do |user|
    #       user.full_name
    #     end
    #   end
    #
    # @param [ Symbol ] name The name of the attribute.
    # @param [ Hash ] options The attribute options.
    #
    # @option options [ String ] :from The version the field is available from.
    # @option options [ String ] :to The version the field is available to.
    #
    # @return [ Attribute ] The attribute object for the field.
    #
    # @since 0.0.0
    def detail(name, options = {}, &block)
      normalized = name.to_sym
      detail_attributes[normalized] = Attribute.new(normalized, options, &block)
    end

    # Get all the attributes that are used in the detail representation.
    #
    # @example Get all the detail attributes fields.
    #   class UserResource
    #     include Darstellung::Representable
    #   end
    #
    #   UserResource.detail_attributes
    #
    # @return [ Hash ] The name/attribute pairs.
    #
    # @since 0.0.0
    def detail_attributes
      @detail_attributes ||= {}
    end
  end
end
