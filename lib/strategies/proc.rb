module MotionBindable::Strategies

  class Proc < ::MotionBindable::Strategy

    def refresh
      update_attribute
    end

    private

    def update_attribute
      self.attribute = bound.call
    end

  end

end
