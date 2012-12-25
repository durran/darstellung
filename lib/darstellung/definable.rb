# encoding: utf-8
module Darstellung

  # This module contains access from the instance level to the attribute
  # definitions provided by the macros.
  #
  # @since 0.0.0
  module Definable

    # Get all the attributes that are used in the detail representation.
    #
    # @example Get all the detail attributes fields.
    #   user_resource.detail_attributes
    #
    # @return [ Hash ] The name/attribute pairs.
    #
    # @since 0.0.0
    def detail_attributes
      self.class.detail_attributes
    end

    # Get all the attributes that are used in the summary representation.
    #
    # @example Get all the summary attributes fields.
    #   user_resource.summary_attributes
    #
    # @return [ Hash ] The name/attribute pairs.
    #
    # @since 0.0.0
    def summary_attributes
      self.class.summary_attributes
    end
  end
end
