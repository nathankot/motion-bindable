module MotionBindable::Strategies

  def self.apply
    ::MotionBindable::Strategy.register_strategy(
      MotionBindable::Strategies::UITextField,
      ::UITextField
    )
  end

end
