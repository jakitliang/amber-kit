class Amber::Switch::Content
  attr_accessor :type

  TEXT_CONTENT = 'text/plain'
  FORM_DATA_CONTENT = 'application/x-www-form-urlencoded'
  JSON_CONTENT = 'application/json'

  def initialize(type, data = nil)
    @type = type

    if data
      self.data = data
    end
  end
  
  def data
    @data
  end

  def data=(data)
    @data = data
  end

  def body
    if self.class.include? Amber::Switch::ContentDelegate
      return self.serialize @data
    end
  end

  def body=(body)
    if self.class.include? Amber::Switch::ContentDelegate
      @data = self.deserialize body
      return
    end
  end
end

require "amber/switch/content_delegate"