module MotionBindable

  #
  # Represents a binding strategy. Designed to be as flexible as possible.
  #
  class Strategy

    @strategies_map = [{ class: Strategy, candidates: [Object] }]

    def self.register_strategy(strategy, *objects)
      @strategies_map << { class: strategy, candidates: objects }
    end

    def self.find_by_reference(object)
      @strategies_map.reverse.find do |h|
        h[:candidates].include? object.class
      end.fetch(:class)
    end

    attr_accessor :attribute

    def initialize(attr)
      on_bind
    end

    def refresh; end
    def on_bind; end

  end

end
