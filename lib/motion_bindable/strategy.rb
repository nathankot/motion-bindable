module MotionBindable

  # 
  # Represents a binding strategy. Designed to be as flexible as possible.
  # 
  class Strategy

    attr_accessor :attribute

    def initialize(attr)
      attribute = attr
      on_bind
    end

    def refresh
    end

    def on_bind
    end

  end

end
