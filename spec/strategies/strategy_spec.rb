Strategy = MotionBindable::Strategy

class ObjectOne; attr_accessor :attribute end
class ObjectTwo; attr_accessor :attribute end

class FakeStrategyOne < Strategy; end
class FakeStrategyTwo < Strategy; end

describe 'MotionBindable::Strategy' do

  before do
    Strategy.register_strategy(FakeStrategyOne, ObjectOne)
    Strategy.register_strategy(FakeStrategyTwo, ObjectTwo)
  end

  describe 'class methods' do

    describe 'self#find_by_reference' do

      it 'returns a strategy that specifies the object as a candidate' do
        Strategy.find_by_reference(ObjectOne.new).should.equal FakeStrategyOne
        Strategy.find_by_reference(ObjectTwo.new).should.equal FakeStrategyTwo
      end

    end

  end

  describe 'instance methods' do

    before do
      @object = ObjectOne.new
      @bound = Object.new
      @strategy = Strategy.new(@object, :attribute)
      @strategy.stub!(:watch_bound)
      @strategy.stub!(:watch_object)
    end

    describe '#bind' do
      it 'should respond' do
        @strategy.respond_to?(:bind).should.equal true
      end

      it 'should set the bound object' do
        @strategy.bind(@bound)
        @strategy.bound.should.equal @bound
      end

      it 'should return self' do
        @strategy.bind(@bound).should.equal @strategy
      end

      it 'should call on_object_change if the attribute is not nil' do
        @object.attribute = 'Test'
        @strategy.should.receive(:on_object_change).and_return(true)
        @strategy.bind(@bound)
      end

      it 'should call on_bound_change if the attribute is nil' do
        @object.attribute = nil
        @strategy.should.receive(:on_bound_change).and_return(true)
        @strategy.bind(@bound)
      end
    end

    describe '#attribute=' do
      it 'should be a proxy to set the attribute on the bound object' do
        @strategy.send(:attribute=, 'test')
        @object.send(:attribute).should.equal 'test'
      end
    end

    describe '#unbind' do
      it 'should respond' do
        @strategy.respond_to?(:unbind).should.equal true
      end

      it 'should clear the watcher' do
        wait(0.5) do
          @strategy.instance_variable_get(:@watching).should.equal nil
        end
      end
    end

  end

end
