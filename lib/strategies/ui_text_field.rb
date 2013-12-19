module MotionBindable::Strategies

  class UITextField < ::MotionBindable::Strategy

    def on_bind
      update_attribute
      NSNotificationCenter.defaultCenter.addObserver(
        self,
        selector: :on_change,
        name: UITextFieldTextDidChangeNotification,
        object: bound
      )
    end

    def on_change
      update_attribute
    end

    alias_method :refresh, :on_change

    private

    def update_attribute
      self.attribute = bound.text
    end

  end

end
