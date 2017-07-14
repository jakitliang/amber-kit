class Amber::Http
  attr_reader :header

  def initialize(socket)
    @header = {}
    @body_raw_data = ""
    @socket = socket
  end
end