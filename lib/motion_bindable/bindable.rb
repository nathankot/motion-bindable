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

    def bind_attributes(attrs, object = self)
      attrs.each_pair do |k, v|
        case v
        when Hash then bind_attributes(v, object.send(k))
        when Array then v.each { |o| bind strategy_for(o).new(object, k).bind(o) }
        else bind strategy_for(v).new(object, k).bind(v)
        end
      end
    end

    def bind(strategy)
      @bindings ||= []
      @bindings << strategy
      self
    end

    def refresh
      @bindings.each { |b| b.refresh }
      self
    end

    private

    def strategy_for(reference)
      Strategy.find_by_reference(reference)
    end

    def underscore(str)
      str.gsub(/::/, '/')
      .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      .gsub(/([a-z\d])([A-Z])/,'\1_\2')
      .tr("-", "_")
      .downcase
    end

  end

end
