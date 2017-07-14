module Amber::DataDelegate
  def assign(value)
    @value = value
  end

  def fetch
    @value
  end
end