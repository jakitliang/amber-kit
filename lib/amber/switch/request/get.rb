class Amber::Switch::Request::Get < Amber::Switch::Request
  def initialize(url = "")
    super Amber::Switch::Request::GET_METHOD, url
  end
end