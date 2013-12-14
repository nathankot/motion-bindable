module MotionBindable

  # This allows objects to register multiple delegates
  class DelegateProxy

    attr_accessor :delegates

    def initialize(*initial_delegates)
      self.delegates = initial_delegates
    end

    def method_missing(name, *args, &block)
      responses = []
      delegates.each do |delegate|
        responses << delegate.send(name, *args, &block) if delegate.respond_to?(name)
      end

      responses.first
    end

  end

end
