class Amber::Data::StringData < Amber::Data
  include Amber::DataDelegate

  def initialize(value = '')
    @delegate = self

    self.assign(value)
  end
  
  def assign(value)
    @value = value.to_s
  end
end