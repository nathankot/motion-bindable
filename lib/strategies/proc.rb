module MotionBindable::Strategies
  class Proc < ::MotionBindable::Strategy
    WATCH_TICK = 0.2

    def bound_value
      bound.call
    end

    def object_value
      attribute
    end

    def on_bound_change(new = nil)
      self.attribute = new || bound.call
    end

    def unbind
      @watching = false
      super
    end

    def start_observing
      @watching = true
      watch
    end

    private

    def watch
      dispatcher.async do
        if @watching
          new = bound_value
          on_bound_change(new) if new != @old_bound_value
          @old_bound_value = nil
          dispatcher.after(WATCH_TICK) { watch }
        end
      end
    end

    def dispatcher
      @dispatcher ||= begin
        Dispatch::Queue.concurrent 'org.motion.bindable'
      end
    end
  end
end
