module MotionBindable::StrategyHelpers
  # A generic method for observing an object's attribute that is
  # being bound to.
  #
  # Where strategies deal with observing a large variety of possible bound
  # objects, this method will only have to worry about a small set of possible
  # objects being binded to, KVO should actually cover most cases.
  def observe_object(&block)
    @_observe_object_cb = block

    if defined?(MotionModel::Model) && object.is_a?(MotionModel::Model)
      @_observe_object_mode = :motion_model
      start_observing_motion_model
    else
      @_observe_object_mode = :kvo
      start_observing_kvo
    end
  end

  def stop_observe_object
    case @_observe_object_mode
    when :kvo then stop_observing_kvo
    end

    @_observe_object_mode,
    @_observe_object_block = nil
  end

  # NSKeyValueObserving Protocol

  def observeValueForKeyPath(_, ofObject: _, change: change, context: _)
    @_observe_object_cb.call(change[:old], change[:new])
  end

  private

  def start_observing_motion_model
    @_observe_object_old_value = object.send(attr_name)
    NSNotificationCenter.defaultCenter.addObserverForName(
      'MotionModelDataDidChangeNotification',
      object: object,
      queue: nil,
      usingBlock: proc do |notification|
        new = notification.object.send(attr_name)
        @_observe_object_cb.call(
          @_observe_object_old_value,
          new
        ) if @_observe_object_cb
        @_observe_object_old_value = new
      end
    )
  end

  def start_observing_kvo
    object.addObserver(
      self,
      forKeyPath: attr_name,
      options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld,
      context: nil
    )
  end

  def stop_observing_kvo
    object.removeObserver(
      self,
      forKeyPath: attr_name
    )
  rescue
    # See: http://nshipster.com/key-value-observing/
    true
  end
end
