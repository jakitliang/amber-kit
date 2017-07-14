class Amber::Data::IntegerData < Amber::Data
  include Amber::DataDelegate

  def initialize(value = 0)
    @delegate = self

    self.assign(value)
  end
  
  def assign(value)
    @value = value.to_i
  end
end