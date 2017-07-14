class Amber::Switch::Request
  attr_accessor :method, :url, :header

  GET_METHOD = 'GET'
  POST_METHOD = 'POST'
  PUT_METHOD = 'PUT'
  DELETE_METHOD = 'DELETE'

  def initialize(method, url)
    @method = method
    @url = url
    @header = {}
  end
end

require "json"
