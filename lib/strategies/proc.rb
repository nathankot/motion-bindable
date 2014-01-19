module MotionBindable::Strategies

  class Proc < ::MotionBindable::Strategy

    def refresh_bound
      bound.call
    end

    def refresh_object
      attribute
    end

    def on_bound_change(new = nil)
      self.attribute = new || bound.call
    end

    def unbind
      @watching = false
      super
    end

  end

end
