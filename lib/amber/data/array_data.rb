class Amber::Data::ArrayData < Amber::Data
  include Amber::DataDelegate

  def initialize(value = [])
    @delegate = self

    self.assign(value)
  end
  
  def assign(value)
    if value.is_a? Array
      @value = value
    end
  end
end