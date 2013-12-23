module MotionBindable::Strategies

  class UITextField < ::MotionBindable::Strategy

    def start_observing_bound
      @bound_observer = NSNotificationCenter.defaultCenter.addObserverForName(
        UITextFieldTextDidChangeNotification,
        object: bound,
        queue: nil,
        usingBlock: proc { |_| on_bound_change }
      )
    end

    def start_observing_object
      # Observe the attribute
      object.addObserver(
        self,
        forKeyPath: @attr_name,
        options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld,
        context: nil
      )
    end

    def on_bound_change(new = nil)
      self.attribute = new || bound.text
    end

    def on_object_change(new = nil)
      @bound.text = new || attribute
    end

    def unbind
      NSNotificationCenter.defaultCenter.removeObserver(@bound_observer)
      object.removeObserver(self, forKeyPath: @attr_name)
      super
    end

    # NSKeyValueObserving Protocol

    def observeValueForKeyPath(_, ofObject: _, change: _, context: _)
      on_object_change
    end

  end

end
