module MotionBindable

  #
  # # Bindable Module
  #
  # Allow attributes of an object to be bound to other arbitrary objects
  # through unique strategies.
  #
  module Bindable

    def bind_attributes(attrs, object = self)
      attrs.each_pair do |k, v|
        case v
        # Recurse if another hash
        when Hash then bind_attributes(v, object.send(k))
        # Allow binding multiple bound if an array
        when Array then v.each { |v| bind strategy_for(v).new(object, k).bind(v) }
        # Otherwise bind
        else bind strategy_for(v).new(object, k).bind(v)
        end
      end
    end

    def bind(strategy)
      @bindings ||= []
      @bindings << strategy
      self
    end

    def unbind_all
      @bindings ||= []
      @bindings.each { |b| b.unbind }
      @bindings = []
    end

    def strategy_for(reference)
      Strategy.find_by_reference(reference)
    end

  end

end
