class Amber::Data
  def initialize
    @value = nil
    @delegate = nil
  end
  
  def value
    @delegate.fetch if @delegate.class.include?(Amber::DataDelegate)
  end

  def value=(value)
    @delegate.assign(value) if @delegate.class.include?(Amber::DataDelegate)
  end
end