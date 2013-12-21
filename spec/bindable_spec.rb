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
    @object.nested = FakeBindable.new
    @object.stub!(:strategy_for) { |_| FakeStrategy }
    @bound = Object.new
    FakeStrategy.stub!(:new) { |_, _| @strategy }
  end

  describe '#bind_attributes' do

    context 'un-nested' do
      before do
        @strategy = FakeStrategy.new(@object, :attribute)
      end

      it 'accepts an array of objects' do
        @attributes = []
        @strategy.stub!(:bind) { |attribute| @attributes << attribute }
        @bound2 = Object.new
        @object.bind_attributes(attribute: [@bound, @bound2])
        @attributes.length.should.equal 2
      end

      it 'passes the strategy to bind' do
        @called = false
        @object.stub!(:bind) { |_| @called = true }
        @object.bind_attributes({ attribute: @bound })
        @called.should.equal true
      end
    end

    context 'nested' do
      before do
        @strategy = FakeStrategy.new(@object.nested, :attribute)
      end

      it 'accepts nested attributes' do
        @strategy.stub!(:bind) { |bound| @bounded = bound }
        @object.bind_attributes nested: { attribute: @bound }
        @bounded.should.equal @bound
      end
    end

  end

  describe '#bind' do
    before do
      @strategy = FakeStrategy.new(@object, :attribute)
      @strategy.bind(@bound)
    end

    it 'should be chainable' do
      @object.bind(@strategy).should.equal @object
    end
  end

  describe '#unbind' do
    before do
      @strategy = FakeStrategy.new(@object, :attribute)
      @strategy.bind(@bound)
      @object.bind(@strategy)
    end

    it 'should send unbind to the strategy' do
      @strategy.should.receive(:unbind).and_return true
      @object.unbind(@strategy)
    end
  end

  describe '#unbind_all' do
    before do
      @strategy1 = FakeStrategy.new(@object, :attribute)
      @strategy1.bind(@bound)
      @object.bind(@strategy1)

      @strategy2 = FakeStrategy.new(@object, :attribute)
      @strategy2.bind(@bound)
      @object.bind(@strategy2)
    end

    it 'should send unbind to all strategies' do
      @strategy1.should.receive(:unbind).and_return(true)
      @strategy2.should.receive(:unbind).and_return(true)
      @object.unbind_all
    end
  end

end
