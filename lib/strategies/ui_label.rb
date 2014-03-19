module MotionBindable::Strategies
  class UILabel < ::MotionBindable::Strategy
    include MotionBindable::StrategyHelpers

    def start_observing_object
      observe_object { |_, new| on_object_change(new) }
    end

    def on_object_change(new = nil)
      @bound.text = (new || attribute)
      @bound.setNeedsDisplay
    end

    def observeValueForKeyPath(_, ofObject: _, change: _, context: _)
      on_object_change
    end

    def unbind
      stop_observe_object
      super
    end
  end
end
