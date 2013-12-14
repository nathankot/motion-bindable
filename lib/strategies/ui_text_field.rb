module MotionBindable::Strategies

  class UITextField < ::MotionBindable::Strategy

    def on_bind
      if bound.delegate.is_a? ::MotionBindable::DelegateProxy
        bound.delegate.delegates << self
      else
        bound.delegate = ::MotionBindable::DelegateProxy.new(
          bound.delegate,
          self
        )
      end

      update_attribute
    end

    def textFieldDidEndEditing(_)
      update_attribute
    end

    private

    def update_attribute
      self.attribute = bound.text
    end

  end

end
