class FakeModel
  include MotionBindable::Bindable
  attr_accessor :attribute
  attr_accessor :nested
end

describe 'MotionBindable::Strategies::UITextField' do

  before do
    MotionBindable::Strategy.register_strategy(
      MotionBindable::Strategies::UITextField,
      UITextField
    )

    @app = UIApplication.sharedApplication
    @text_field = UITextField.alloc.initWithFrame [[110, 60], [100, 26]]
  end

  context 'nested model' do

    before do
      @object = FakeModel.new
      @object.nested = FakeModel.new
    end

    context 'text set and then bound' do

      before do
        @text_field.text = 'Just testing.'
        @object.bind_attributes({
          attribute: @text_field,
          nested: {
            attribute: @text_field
          }
        })
      end

      it 'should update the root attribute' do
        @object.attribute.should.equal 'Just testing.'
      end

      it 'should update the nested attribute' do
        @object.nested.attribute.should.equal 'Just testing.'
      end

      context 'text field is updated' do

        before do
          @text_field.text = 'Updated.'
          @text_field.delegate.textFieldDidEndEditing(self)
        end

        it 'should update the root attribute' do
          @object.attribute.should.equal 'Updated.'
        end

        it 'should update the nested attribute' do
          @object.nested.attribute.should.equal 'Updated.'
        end

      end

    end

  end


end
