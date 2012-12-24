# encoding: utf-8
module Darstellung

  # An attribute is any field that can be represented. This class provides
  # extra behavior around when and how these fields get represented.
  #
  # @since 0.0.0
  class Attribute

    # @attribute [r] name The name of the attribute.
    # @attribute [r] options The attribute options.
    # @attribute [r] block The block to call to get the value.
    attr_reader :name, :options, :block

    # Determines if the attribute is displayable in the representation given
    # the provided version.
    #
    # @example Is the attribute displayable?
    #   attribute.displayable?("1.0.0")
    #
    # @note This method assumes that API versions are following the Semantic
    #   Versioning Specificaion, and does its comparison of version strings
    #   with this in mind.
    #
    # @param [ String ] version The version number.
    #
    # @return [ true, false ] If the attribute is displayable.
    #
    # @see http://semver.org/
    #
    # @since 0.0.0
    def displayable?(version)
      from <= version && version <= to(version)
    end

    # Initialize the new attribute.
    #
    # @example Initialize the new attribute.
    #   Darstellung::Attribute.new(:name, version: "1.0.1")
    #
    # @param [ Symbol ] name The name of the attribute.
    # @param [ Hash ] options The attribute options.
    #
    # @option options [ String, Range ] :version The version the attribute
    #   appears in.
    #
    # @since 0.0.0
    def initialize(name, options = {}, &block)
      @name, @options, @block = name, options, block
    end

    # Get the value for the attribute from the provided resource.
    #
    # @example Get the value for the attribute.
    #   attribute.value(user)
    #
    # @param [ Object ] resource The resource to execute on.
    #
    # @return [ Object ] The value of the resource.
    #
    # @since 0.0.0
    def value(resource)
      block ? block.call(resource) : resource.__send__(name)
    end

    private

    def from
      options[:from] || "0.0.0"
    end

    def to(version)
      options[:to] || "#{version}+"
    end
  end
end
