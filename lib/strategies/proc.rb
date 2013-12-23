module MotionBindable::Strategies

  class Proc < ::MotionBindable::Strategy

    def refresh_bound
      bound.call
    end

    def on_bound_change(new = nil)
      self.attribute = new || bound.call
    end

  end

end
