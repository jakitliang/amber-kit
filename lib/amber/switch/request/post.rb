class Amber::Switch::Request::Post < Amber::Switch::Request
  attr_accessor :content
  
  def initialize(url = "")
    super Amber::Switch::Request::POST_METHOD, url
  end
end