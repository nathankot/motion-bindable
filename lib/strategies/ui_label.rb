module MotionBindable::Strategies

  class UILabel < ::MotionBindable::Strategy

    def start_observing_object
      # Observe the attribute
      object.addObserver(
        self,
        forKeyPath: attr_name,
        options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld,
        context: nil
      )
    end

    def on_object_change(new = nil)
      @bound.text = (new || attribute)
      @bound.setNeedsDisplay
    end

    def observeValueForKeyPath(_, ofObject: _, change: _, context: _)
      on_object_change
    end

  end

end
