module MotionBindable::Strategies

  class UITextField < ::MotionBindable::Strategy

    include BW::KVO

    def start_observing_bound
      NSNotificationCenter.defaultCenter.addObserverForName(
        UITextFieldTextDidChangeNotification,
        object: bound,
        queue: nil,
        usingBlock: proc { |_| on_bound_change }
      )
    end

    def start_observing_object
      # Observe the attribute
      observe(object, @attr_name) { |_, _| on_object_change }
    end

    def on_bound_change(new = nil)
      self.attribute = new || bound.text
    end

    def on_object_change(new = nil)
      @bound.text = new || attribute
    end

    def unbind
      App.notification_center.unobserve(@bound_observer)
      unobserve(object, @attr_name)
      super
    end

  end

end
