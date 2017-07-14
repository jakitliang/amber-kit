class Amber::Data::DateData < Amber::Data
  include Amber::DataDelegate

  def initialize(value = Time.new)
    @delegate = self

    self.assign(value)
  end
  
  def assign(value)
    if (value.is_a?(Integer)) || (value.is_a?(Float))
      @value = Time.at(value)
    end
  end
end