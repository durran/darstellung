# encoding: utf-8
module Darstellung

  # This module provides all the class level macros for defining
  # representations.
  #
  # @since 0.0.0
  module Macros

    def detail(name, options = {})
      normalized = name.to_sym
      detail_attributes[normalized] = Attribute.new(normalized)
    end

    def detail_attributes
      @detail_attributes ||= {}
    end

    def summary(name, options = {})

    end

    def summary_attributes
      @summary_attributes ||= {}
    end
  end
end
