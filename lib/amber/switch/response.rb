class Amber::Switch::Response
  attr_accessor :status, :header, :content

  def initialize
    @status = false
    @header = {}
  end
end

require "json"
