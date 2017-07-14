class Amber::Switch::Content::FormData < Amber::Switch::Content
  include Amber::Switch::ContentDelegate

  def initialize(data = {})
    super Amber::Switch::Content::FORM_DATA_CONTENT, data
  end
  
  def data=(data)
    if data.is_a? Hash
      super
    end
  end

  def serialize(data)
    form_data_string = ""
    if data.is_a? Hash
      form_data_items = []
      data.each do |key, value|
        form_data_item = URI.encode(key) + "=" + URI.encode(value)
        form_data_items.push form_data_item
      end
      form_data_string = form_data_items.join "&"
    end
    form_data_string
  end

  def deserialize(data)
    form_data = {}
    form_data_string = data.to_s
    form_data_items = form_data_string.split '&'
    form_data_items.each do |form_data_item|
      info = form_data_item.split '='
      if info.length == 2
        key = URI.encode info[0]
        value = URI.decode info[1]
        form_data[key] = value
      end
    end
    form_data
  end
end

require "uri"