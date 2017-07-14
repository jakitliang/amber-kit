class Amber::View
  attr_accessor :code, :header, :content

  def initialize(code = 404, header = {}, content = nil)
    @code = code
    @header = header
    @content = content
  end
end