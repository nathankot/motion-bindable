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
    end

    describe '#refresh' do
      it 'should respond' do
        @strategy.respond_to?(:refresh).should.equal true
      end
    end

    describe '#attribute=' do
      it 'should be a proxy to set the attribute on the bound object' do
        @strategy.attribute = 'test'
        @object.attribute.should.equal 'test'
      end
    end

  end

end
