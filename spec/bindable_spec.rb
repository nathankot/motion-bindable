describe 'MotionBindable::Bindable' do

  class FakeStrategy < MotionBindable::Strategy
  end

  class FakeBindable
    include MotionBindable::Bindable
    attr_accessor :attribute
    attr_accessor :nested
  end

  before do
    @object = FakeBindable.new
    @bound = Object.new
    @object.stub!(:strategy_for) { |_| FakeStrategy }
  end

  describe '#bind_attributes' do
    before do
      @object.nested = FakeBindable.new
    end

    it 'accepts nested attributes' do
      FakeStrategy.stub!(:bind) do |attribute|
        @attribute = attribute
      end

      @object.bind_attributes({
        attribute: @bound,
        nested: {
          attribute: @bound
        }
      })

      @attribute.should.equal @object.nested.attribute
    end

    it 'passes the strategy to bind' do
      @called = false
      @object.stub!(:bind) { |_| @called = true }
      @object.bind_attributes({ attribute: @bound })
      @called.should.equal true
    end

  end

  describe '#bind' do

    before do
      @strategy = FakeStrategy.new(@object.attribute)
    end

    it 'should be chainable' do
      @object.bind(@strategy).should.equal @object
    end

  end

end
