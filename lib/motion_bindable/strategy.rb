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

    attr_accessor :object
    attr_accessor :level
    attr_accessor :bound

    def initialize(object, *level)
      self.object = object
      self.level = level
    end

    def bind(bound)
      self.bound = bound
      on_bind

      self
    end

    # You can either choose to just override `#refresh` for objects that can't
    # be bound with callbacks. Or override `#on_bind` for objects that can be
    # bound with a callback.
    def refresh; end
    def on_bind
      refresh
    end

    def attribute
      level.reduce(object) do |o, l|
        if o.respond_to?(l) then o.send(l)
        else o[l]
        end
      end
    end

    def attribute=(value)
      level.reduce(object) do |o, l|
        if o.respond_to?(:"#{l.to_s}=") then o.send(:"#{l.to_s}=", value)
        elsif o.is_a?(Hash) && o.has_key?(l) then o[l] = value
        else raise "MotionBindable: #{o.class} cannot write attribute '#{l}'"
        end
      end
    end

  end

end
