module MotionBindable

  #
  # # Bindable Module
  #
  # Allow attributes of an object to be bound to other arbitrary objects through
  # unique strategies.
  #
  # ## One-way binding
  #
  # Currently bindings are only one-way, i.e change in the arbitrary object affects
  # the bindable object but not vice-versa.
  #
  module Bindable

    def bind_attributes(attrs, level = [])
      attrs.each_pair do |attribute, object|
        level << attribute
        next bind_attributes(attribute, level) if v.is_a?(Hash)
        bind level, strategy: object
      end
    end

    def bind(level, strategy: strat)
      level = [level] unless level.respond_to?(:reduce)
      @bindings ||= []
      @bindings << strategy_for(strat).new(get_attr(level))
    end

    def get_attr(level)
      obj = self
      level.reduce(obj) do |obj, l|
        if obj.respond_to?(l.to_sym) then obj.send(l.to_sym)
        else obj[l.to_sym]
        end
      end
    end

    def refresh
      @bindings.each { |b| b.refresh }
    end

    private

    def underscore(str)
      str.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
    end

  end

end
