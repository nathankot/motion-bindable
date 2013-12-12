describe 'MotionBindable::Bindable' do

  before do
    Object.instance_eval do
      attr_accessor :attribute
    end
    @object = Object.new
    @object.extend MotionBindable::Bindable
    @bound = Object.new
  end

  describe '#bind' do

    context 'on a proc strategy' do

      before do
        @response = 'test'
        @object.bind :attribute, strategy: proc { 'test' }
      end

      it 'sets the attribute after bind' do
        @object.attribute.should.equal 'test'
      end

      describe '#refresh' do
        before { @response = 'again' }
        it 'updates the attribute again' do
          @object.attribute.should.equal 'test'
          @object.refresh.attribute.should.equal 'again'
        end
      end

    end

    context 'on a custom strategy' do

      before do
        @called = 0
        @object.stub!(:strategy_for).with(:custom_strategy).and_return Proc.new do
          @called += 1
        end
      end

      it 'only calls the strategy once' do
        @object.bind :attribute, strategy: :custom_strategy
        @called.should.equal 1
        @object.bind :attribute, strategy: :custom_strategy
        @called.should.equal 1
      end

      it 'doesnt call the strategy even after refresh' do
        @object.bind :attribute, strategy: :custom_strategy
        @called.should.equal 1
        @object.refresh
        @called.should.equal 1
      end

    end

  end

  describe '#bind_attributes' do

    it 'should exist' do
      @object.respond_to?(:bindAttributes).should.equal true
    end

  end

  describe 'picking the bind strategy' do
  end

end
