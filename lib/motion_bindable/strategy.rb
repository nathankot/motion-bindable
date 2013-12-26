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
    attr_reader :attr_name

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
      @watching = nil
    end

    private # Methods to leave alone

    def attribute
      object.send(attr_name)
    end

    def attribute=(value)
      object.send(:"#{attr_name.to_s}=", value)
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
      sides = []

      if respond_to?(:start_observing_bound) then start_observing_bound
      elsif respond_to?(:refresh_bound) && respond_to?(:on_bound_change)
        sides << :bound
      end
      if respond_to?(:start_observing_object) then start_observing_object
      elsif respond_to?(:refresh_object) && respond_to?(:on_object_change)
        sides << :object
      end

      watch(sides)
    end

    def watch(sides)
      @watching = dispatcher.async do
        bound_result = refresh_bound if sides.include?(:bound)
        object_result = refresh_object if sides.include?(:object)
        on_bound_change(bound_result) if bound_result
        on_object_change(object_result) if object_result
        dispatcher.after(WATCH_TICK) { watch(sides) } unless @watching
      end
    end

    def dispatcher
      @dispatcher ||= begin
        Dispatch::Queue.concurrent 'motion.bindable'
      end
    end

  end

end
