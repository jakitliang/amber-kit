class Amber::RoutePath
  attr_reader :child, :method, :callback
  
  def initialize(method = "GET", callback = nil)
    @child = {}
    @method = method
    @callback = callback
  end

  def has_child?
    !@child.empty?
  end

  def can_call?
    @callback != nil
  end

  def add_child(path, child)
    if child.is_a? Amber::RoutePath
      @child[path] = child
      return
    end

    raise ArgumentError, "Child should be a route item"
  end

  def method=(method)
    @method = method
  end

  def callback=(callback)
    if callback.is_a? Proc
      @callback = callback
      return
    end

    raise ArgumentError, "Callback should be a proc"
  end
end