class Amber::Switch::Content::Text < Amber::Switch::Content
  include Amber::Switch::ContentDelegate

  def initialize(data = "")
    super Amber::Switch::Content::TEXT_CONTENT, data
  end
  
  def data=(data)
    if data.is_a? String
      super
    end
  end
  def serialize(data)
    data.to_s
  end

  def deserialize(data)
    data.to_s
  end
end

require "amber/switch/content_delegate"