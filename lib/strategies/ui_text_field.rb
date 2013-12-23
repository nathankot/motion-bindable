module MotionBindable::Strategies

  class UITextField < ::MotionBindable::Strategy

    include BW::KVO

    def on_bind
      refresh

      # Observe the bound object
      NSNotificationCenter.defaultCenter.addObserver(
        self,
        selector: :on_bound_change,
        name: UITextFieldTextDidChangeNotification,
        object: bound
      )

      # Observe the attribute
      observe(object, @attr_name) { |_, _| on_object_change }
    end

    def on_bound_change
      self.attribute = bound.text unless bound.text.empty?
    end

    def on_object_change
      @bound.text = attribute
    end

    def unbind
      App.notification_center.unobserve(@bound_observer)
      unobserve(object, @attr_name)
    end

    # Text field takes precedence
    alias_method :refresh, :on_bound_change

  end

end
