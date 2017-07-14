class Amber::Data::FloatData < Amber::Data
  include Amber::DataDelegate

  def initialize(value = 0.0)
    @delegate = self

    self.assign(value)
  end
  
  def assign(value)
    @value = value.to_f
  end
end