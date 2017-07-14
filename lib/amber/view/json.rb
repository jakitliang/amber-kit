class Amber::View::Json < Amber::View
  def initialize(code = 404, header = {}, data = nil)
    super code, header, Amber::Switch::Content::Json.new

    if data
      self.content.data = data
    end
  end
end