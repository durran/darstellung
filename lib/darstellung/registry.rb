# encoding: utf-8
module Darstellung

  # Contains information on all versions in the API that have been registered.
  # This is determined from the various "from" and "to" options provided to the
  # macros.
  #
  # @since 0.0.0
  module Registry
    extend self

    # Register a set of options provided to a representation macro.
    #
    # @example Register the options.
    #   Dartellung::Registry.register(from: "1.0.0", to: "2.0.0")
    #
    # @note This takes the "from" and "to" options and registers them as
    #   official API versions.
    #
    # @param [ Hash ] options The macro options.
    #
    # @return [ Array<String> ] All the registered versions.
    #
    # @since 0.0.0
    def register(options)
      from, to = options[:from], options[:to]
      registered_versions[from] = true if from
      registered_versions[to] = true if to
      versions
    end

    # Is a particular version registered with the API?
    #
    # @example Check if the version is registered.
    #   Darstellung::Registry.registered?("2.1.5")
    #
    # @param [ String ] version The version to check.
    #
    # @return [ true, false ] If the version is registered.
    #
    # @since 0.0.0
    def registered?(version)
      registered_versions[version]
    end

    # Validate that the provided version is registered.
    #
    # @example Validate the version.
    #   Darstellung::Registry.validate!("1.0.5")
    #
    # @param [ String ] version The version to validate.
    #
    # @raise [ NotRegistered ] If the version is not registered.
    #
    # @since 0.0.0
    def validate!(version)
      unless registered?(version)
        raise NotRegistered.new("#{version} is not a valid API version.")
      end
    end

    # Provides a list of all registered versions in the API.
    #
    # @example List all versions.
    #   Darstellung::Registry.versions
    #
    # @return [ Array<String> ] All the registered versions.
    #
    # @since 0.0.0
    def versions
      registered_versions.keys
    end

    # Raised when validating a version that does not exist in the registry.
    #
    # @since 0.0.0
    class NotRegistered < Exception; end

    private

    def registered_versions
      @registered_versions ||= {}
    end
  end
end
