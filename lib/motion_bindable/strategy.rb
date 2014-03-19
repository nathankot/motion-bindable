module MotionBindable
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
    attr_reader :attr_name

    def initialize(object, attr_name)
      @attr_name = attr_name.to_sym
      self.object = object
    end

    public # (Optional) Methods to override

    # def start_observing; end
    # def start_observing_bound; end
    # def start_observing_object; end
    # def on_object_change; end
    # def on_bound_change; end

    def bound_value
    end

    def object_value
    end

    def bind(bound)
      self.bound = bound
      initial_state
      start_listen
      self
    end

    def unbind
    end

    private # Methods to leave alone

    def attribute
      object.send(attr_name)
    end

    def attribute=(value)
      object.send(:"#{attr_name.to_s}=", value)
    end

    def initial_state
      # We try to find an existing value and fill it up
      if attribute.nil? && respond_to?(:on_bound_change)
        on_bound_change(bound_value)
      elsif respond_to?(:on_object_change)
        on_object_change(object_value)
      end
    end

    def start_listen
      start_observing if respond_to?(:start_observing)
      start_observing_bound if respond_to?(:start_observing_bound)
      start_observing_object if respond_to?(:start_observing_object)
    end
  end
end
