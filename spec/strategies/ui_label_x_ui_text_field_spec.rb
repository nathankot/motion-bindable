describe 'UITextField + UILabel' do

  before do
    @text_field = UITextField.alloc.initWithFrame [[110, 60], [100, 26]]
    @label = UILabel.alloc.initWithFrame [[110, 60], [100, 26]]
    @object = FakeModel.new
  end

  context 'attribute not set yet' do

    before do
      @object.bind_attributes attribute: [@text_field, @label]
    end

    it 'should update the bound when attribute is updated' do
      @object.attribute = 'Hello'
      @text_field.text.should.equal 'Hello'
      @label.text.should.equal 'Hello'
    end

    describe 'updating the text' do

      before do
        @text_field.text = 'Superman'
        NSNotificationCenter.defaultCenter.postNotificationName(
          UITextFieldTextDidChangeNotification, object: @text_field
        )
      end

      it 'should update the attribute when the text field is updated' do
        @object.attribute.should.equal 'Superman'
      end

      it 'should update the label when the text field is updated' do
        @label.text.should.equal 'Superman'
      end

    end

  end

  context 'attribute set first' do

    before do
      @object.attribute = 'Testing'
      @object.bind_attributes attribute: [@text_field, @label]
    end

    it 'should set the field and label' do
      @text_field.text.should.equal 'Testing'
      @label.text.should.equal 'Testing'
    end

    describe 'updating the text' do

      before do
        @text_field.text = 'Superman'
        NSNotificationCenter.defaultCenter.postNotificationName(
          UITextFieldTextDidChangeNotification, object: @text_field
        )
      end

      it 'should update the attribute when the text field is updated' do
        @object.attribute.should.equal 'Superman'
      end

      it 'should update the label when the text field is updated' do
        @label.text.should.equal 'Superman'
      end
    end

  end

end
