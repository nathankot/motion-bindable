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
    @bound = Object.new
    @object.should.receive(:strategy_for) do
      mock('FakeStrategy', new: @strategy)
    end.times(:any)
  end

  describe '#bind_attributes' do

    context 'un-nested' do
      before do
        @strategy = FakeStrategy.new(@object, :attribute)
      end

      it 'accepts an array of objects' do
        @bound2 = Object.new
        @strategy.should.receive(:bind).times(2)
        @object.bind_attributes(attribute: [@bound, @bound2])
      end

      it 'passes the strategy to bind' do
        @strategy.should.receive(:bind).once
        @object.bind_attributes(attribute: @bound)
      end
    end

    context 'nested' do
      before do
        @strategy = FakeStrategy.new(@object.nested, :attribute)
      end

      it 'accepts nested attributes' do
        @strategy.should.receive(:bind) { |bound| @bounded = bound }.times(:any)
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

  describe '#unbind_all' do

    it 'can be called even if object isnt bound' do
      lambda { @object.unbind_all }.should.not.raise(Exception)
    end

    context 'object is bound' do
      before do
        @strategy1 = FakeStrategy.new(@object, :attribute)
        @strategy1.bind(@bound)
        @object.bind(@strategy1)
        @strategy2 = FakeStrategy.new(@object.nested, :attribute)
        @strategy2.bind(@bound)
        @object.bind(@strategy2)
      end

      it 'should send unbind to all strategies' do
        @strategy1.should.receive(:unbind).once
        @strategy2.should.receive(:unbind).once
        @object.unbind_all
      end
    end

  end

end
