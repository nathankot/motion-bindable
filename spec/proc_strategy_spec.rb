class FakeBound
  attr_accessor :attribute
end

class FakeModel
  include MotionBindable::Bindable
  attr_accessor :attribute
  attr_accessor :nested
end

describe 'MotionBindable::Strategies::Proc' do

  before do
    MotionBindable::Strategy.register_strategy(
      MotionBindable::Strategies::Proc,
      Proc
    )
  end

  context 'nested model' do

    before do
      @bound = FakeBound.new
      @bound.attribute = 'Testing.'
      @object = FakeModel.new
      @object.nested = FakeModel.new
    end

    context 'is bound' do

      before do
        @object.bind_attributes({
          attribute: proc { @bound.attribute },
          nested: {
            attribute: proc { @bound.attribute }
          }
        })
      end

      it 'should refresh upon bind' do
        @object.attribute.should.equal 'Testing.'
        @object.nested.attribute.should.equal 'Testing.'
      end

      it 'can refresh manually' do
        @bound.attribute = 'Updated.'
        @object.refresh.attribute.should.equal 'Updated.'
        @object.refresh.nested.attribute.should.equal 'Updated.'
      end

    end

  end


end
