describe 'MotionBindable::Strategies::UILabel' do

  before do
    @label = UILabel.alloc.initWithFrame [[110, 60], [100, 26]]
    @label2 = UILabel.alloc.initWithFrame [[110, 60], [100, 26]]
    @object = FakeModel.new
    @object.nested = FakeModel.new
  end

  context 'attribute is not set yet' do

    before do
      @object.bind_attributes({
        attribute: @label,
        nested: { attribute: @label2 }
      })
    end

    it 'should update the label on change' do
      @object.attribute = 'one'
      @object.nested.attribute = 'two'
      @label.text.should.equal 'one'
      @label2.text.should.equal'two'
    end

  end

  context 'attribute is set first' do

    before do
      @object.attribute = 'test'
      @object.nested.attribute = 'test2'
      @object.bind_attributes({
        attribute: @label,
        nested: { attribute: @label2 }
      })
    end

    it 'should set the label on bind' do
      @label.text.should.equal 'test'
      @label2.text.should.equal 'test2'
    end

    it 'should change the label when the attribute changes' do
      @object.attribute = 'changed'
      @object.nested.attribute = 'changed2'
      @label.text.should.equal 'changed'
      @label2.text.should.equal 'changed2'
    end

  end

end
