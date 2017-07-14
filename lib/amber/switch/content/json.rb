class Amber::Switch::Content::Json < Amber::Switch::Content
  include Amber::Switch::ContentDelegate

  def initialize(data = {})
    super Amber::Switch::Content::JSON_CONTENT, data
  end
  
  def data=(data)
    if data.is_a? Hash
      super
    end
  end

  def serialize(data)
    begin
      return JSON.generate data
    rescue Exception => e
      p e
    end
    ""
  end

  def deserialize(data)
    if data.is_a? String
      begin
        return JSON.parse data
      rescue Exception => e
        p e
      end
    end
    {}
  end
end

require "amber/switch/content_delegate"