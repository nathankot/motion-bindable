module MotionBindable

  #
  # Represents a binding strategy. Designed to be as flexible as possible.
  #
  class Strategy

    @strategies_map = [{ class: Strategy, candidates: [Object] }]

    def self.register_strategy(strategy, *objects)
      @strategies_map << { class: strategy, candidates: objects }
    end

    def self.find_by_reference(object)
      @strategies_map.reverse.find do |h|
        h[:candidates].one? { |e| object.is_a? e }
      end.fetch(:class)
    end

    attr_accessor :object
    attr_accessor :bound

    def initialize(object, attribute)
      @attribute = attribute.to_sym
      self.object = WeakRef.new(object)
    end

    def bind(bound)
      self.bound = bound
      on_bind

      self
    end

    # You can either choose to just override `#refresh` for objects that can't
    # be bound with callbacks. Or override `#on_bind` for objects that can be
    # bound with a callback.
    def refresh; end
    def on_bind
      refresh
    end

    def attribute
      object.send(@attribute)
    end

    def attribute=(value)
      object.send(:"#{@attribute.to_s}=", value)
    end

  end

end
