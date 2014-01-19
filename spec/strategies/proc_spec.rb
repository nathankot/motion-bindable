class FakeBound
  attr_accessor :attribute
end

describe 'MotionBindable::Strategies::Proc' do

  context 'nested model' do

    before do
      @bound = FakeBound.new
      @bound.attribute = 'Testing.'
      @object = FakeModel.new
      @object.nested = FakeModel.new
    end

    context 'is bound' do

      before do
        @object.bind_attributes(
          attribute: proc { @bound.attribute },
          nested: {
            attribute: proc { @bound.attribute }
          }
        )
      end

      it 'should refresh upon bind' do
        @object.attribute.should.equal 'Testing.'
        @object.nested.attribute.should.equal 'Testing.'
      end

      it 'attribute is updated when the bound object is updated' do
        @bound.attribute = 'updated'
        wait(0.5) do
          @object.attribute.should.equal 'updated'
          @object.nested.attribute.should.equal 'updated'
        end
      end

      context 'unbind is called' do

        before do
          @object.unbind_all
        end

        it 'should not longer update the attribute when the proc changes' do
          @bound.attribute = 'hello'
          wait(0.5) do
            @object.attribute.should.not.equal 'hello'
            @object.nested.attribute.should.not.equal 'hello'
          end
        end

      end

    end

  end

end
