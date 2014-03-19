module MotionBindable::Strategies
  class UITextField < ::MotionBindable::Strategy
    include MotionBindable::StrategyHelpers

    def start_observing_bound
      @bound_observer = NSNotificationCenter.defaultCenter.addObserverForName(
        UITextFieldTextDidChangeNotification,
        object: bound,
        queue: nil,
        usingBlock: proc { |_| on_bound_change }
      )
    end

    def start_observing_object
      observe_object { |_, new| on_object_change(new) }
    end

    def on_bound_change(new = nil)
      self.attribute = (new || bound.text)
    end

    def on_object_change(new = nil)
      @bound.text = (new || attribute)
    end

    def unbind
      NSNotificationCenter.defaultCenter.removeObserver(@bound_observer)
      stop_observe_object
      super
    end
  end
end
