class FakeModel
  include MotionBindable::Bindable
  attr_accessor :nested
  attr_accessor :attribute
  def attribute
    @attribute
  end
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
          nested: { attribute: @text_field }
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
          NSNotificationCenter.defaultCenter.postNotificationName(
            UITextFieldTextDidChangeNotification, object: @text_field
          )
          # BW puts observer cb's into this queue
          NSOperationQueue.mainQueue.waitUntilAllOperationsAreFinished
        end

        it 'should update the root attribute' do
          @object.attribute.should.equal 'Updated.'
        end

        it 'should update the nested attribute' do
          @object.nested.attribute.should.equal 'Updated.'
        end
      end

      context 'bound attribute is updated' do
        before do
          @object.attribute = 'Reverse'
        end

        it 'should update the text field' do
          @text_field.text.should.equal 'Reverse'
        end
      end

      context 'unbind is called' do
        before do
          @object.unbind_all
        end

        it 'should no longer update when the text field changed' do
          @text_field.text = 'ch-changed'
          @object.attribute.should.not.equal 'ch-changed'
        end
      end

    end

  end

end
