Strategy = MotionBindable::Strategy

class ObjectOne; def one; end end
class ObjectTwo; def two; end end

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
      @strategy = Strategy.new(@object)
    end

    describe '#refresh' do
      it 'should respond' do
        @strategy.respond_to?(:refresh).should.equal true
      end
    end

    describe '#on_bind' do
      it 'should respond' do
        @strategy.respond_to?(:on_bind).should.equal true
      end
    end

  end

end
