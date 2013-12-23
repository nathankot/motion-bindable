module MotionBindable

  #
  # Represents a binding strategy. Designed to be as flexible as possible.
  #
  class Strategy

    WATCH_TICK = 0.2

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

    def initialize(object, attr_name)
      @attr_name = attr_name.to_sym
      self.object = object
    end

    public # Methods to override

    # def start_observing_bound; end
    # def start_observing_object; end
    # def update_bound; end
    # def on_object_change(new); end

    def bind(bound)
      self.bound = bound
      on_bind
      self
    end

    def update_object
      attribute
    end

    def on_bound_change(new)
      self.attribute = new
    end

    def unbind
      @watch_bound, @watch_object = nil
    end

    private # Methods to leave alone

    def attribute
      object.send(@attr_name)
    end

    def attribute=(value)
      object.send(:"#{@attr_name.to_s}=", value)
    end

    def on_bind
      if respond_to?(:start_observing_bound) then start_observing_bound
      elsif respond_to?(:update_bound) && respond_to?(:on_bound_change)
        watch_bound
      end

      if respond_to?(:start_observing_object) then start_observing_object
      elsif respond_to?(:update_object) && respond_to?(:on_object_change)
        watch_object
      end
    end

    def watch_bound
      @watch_bound = dispatcher.async do
        if result = update_bound
          on_bound_change(result)
        end
        dispatcher.after(WATCH_TICK) { watch_bound } unless @watch_bound
      end
    end

    def watch_object
      @watch_object = dispatcher.async do
        if result = update_object
          on_object_change(result)
        end
        dispatcher.after(WATCH_TICK) { watch_object } unless @watch_object
      end
    end

    def dispatcher
      @dispatcher ||= begin
        Dispatch::Queue.concurrent 'motion.bindable'
      end
    end

  end

end
