module MotionBindable

  #
  # # Bindable Module
  #
  # Allow attributes of an object to be bound to other arbitrary objects
  # through unique strategies.
  #
  # ## One-way binding
  #
  # Currently bindings are only one-way, i.e change in the arbitrary object
  # affects the bindable object but not vice-versa.
  #
  module Bindable

    def bind_attributes(attrs, level = [])
      attrs.each_pair do |attribute, object|
        level << attribute.to_sym
        next bind_attributes(object, level) if object.is_a?(Hash)
        bind strategy_for(object).new(get_attr(level))
      end
    end

    def bind(strategy)
      @bindings ||= []
      @bindings << strategy
      strategy.refresh
      self
    end

    def refresh
      @bindings.each { |b| b.refresh }
    end

    private

    def strategy_for(reference)
      Strategies.find_by_reference(reference)
    end

    def get_attr(level)
      obj = self
      level.reduce(obj) do |o, l|
        if o.respond_to?(l) then o.send(l)
        else o[l]
        end
      end
    end

    def underscore(str)
      str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end

  end

end
