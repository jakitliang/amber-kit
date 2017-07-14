class Amber::Storage
  attr_reader :status, :data

  def initialize
    @status = false
    @data = nil
  end
end