module MotionBindable

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
    # def refresh_bound; end
    # def on_object_change; end
    # def on_bound_change; end

    def bind(bound)
      self.bound = bound
      initial_state
      start_listen
      self
    end

    def refresh_object
      attribute
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

    def initial_state
      if attribute.nil?
        if respond_to?(:refresh_bound) then on_bound_change(refresh_bound)
        else on_bound_change
        end if respond_to?(:on_bound_change)
      else
        if respond_to?(:refresh_object) then on_object_change(refresh_object)
        else on_object_change(attribute)
        end if respond_to?(:on_object_change)
      end
    end

    def start_listen
      if respond_to?(:start_observing_bound) then start_observing_bound
      elsif respond_to?(:refresh_bound) && respond_to?(:on_bound_change)
        watch_bound
      end

      if respond_to?(:start_observing_object) then start_observing_object
      elsif respond_to?(:refresh_object) && respond_to?(:on_object_change)
        watch_object
      end
    end

    def watch_bound
      @watch_bound = dispatcher.async do
        result = refresh_bound
        on_bound_change(result) if result
        dispatcher.after(WATCH_TICK) { watch_bound } unless @watch_bound
      end
    end

    def watch_object
      @watch_object = dispatcher.async do
        result = refresh_object
        on_object_change(result) if result
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
