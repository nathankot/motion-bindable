class FakeModel
  include MotionBindable::Bindable
  attr_accessor :nested
  attr_accessor :attribute
  def attribute
    @attribute
  end
end
