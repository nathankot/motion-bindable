describe 'MotionBindable::StrategyHelpers' do
  class TestObject
    attr_accessor :prop
  end

  class TestModel
    include MotionModel::Model
    include MotionModel::ArrayModelAdapter
    columns :prop
  end

  class TestStrategy < MotionBindable::Strategy
    include MotionBindable::StrategyHelpers

    def observe(&block)
      observe_object_attr(&block)
    end
  end

  describe '#observe_object_attr' do
    describe 'normal object' do
      before do
        @object = TestObject.new
        @response = nil
        @strategy = TestStrategy.new(@object, :prop)
      end

      it 'should call the cb for changes' do
        @strategy.observe { |old, new| @response = new }
        @object.prop = 'updated'
        wait(0.5) do
          @response.should.equal 'updated'
        end
      end
    end

    describe 'MotionModel' do
      before do
        @object = TestModel.new
        @response = nil
        @strategy = TestStrategy.new(@object, :prop)
      end

      it 'should call the cb for changes' do
        @strategy.observe { |old, new| @response = new }
        @object.prop = 'updated'
        @object.save
        wait(0.5) { @response.should.equal 'updated' }
      end

      it 'should not turn the model.class into a KVO thingy' do
        @strategy.observe { |old, new| @response = new }
        @object.is_a?(MotionModel::Model).should.equal true
      end
    end
  end
end
