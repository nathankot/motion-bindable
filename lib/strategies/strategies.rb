module MotionBindable::Strategies

  def self.apply
    ::MotionBindable::Strategy.register_strategy(
      MotionBindable::Strategies::UITextField,
      ::UITextField
    )
    ::MotionBindable::Strategy.register_strategy(
      MotionBindable::Strategies::UILabel,
      ::UILabel
    )
    ::MotionBindable::Strategy.register_strategy(
      MotionBindable::Strategies::Proc,
      ::Proc
    )
  end

end
