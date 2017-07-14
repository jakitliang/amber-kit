class Amber
  attr_reader :route, :option

  def initialize
    @route = Amber::Route.new
    @option = {}

    if block_given?
      yield self
    end
  end

  def run
    server_port = @option.has_key?("port") ? @option["port"] : 3001
    @server = Amber::Server.new server_port
    @server.base = self
    @server.prepare
    @server.start
  end
end

require "amber/http"
require "amber/http/request"
require "amber/http/response"
require "amber/server"
require "amber/controller"
require "amber/route"
require "amber/route_path"
require "amber/data"
require "amber/data_delegate.rb"
require "amber/data/array_data.rb"
require "amber/data/date_data.rb"
require "amber/data/float_data.rb"
require "amber/data/integer_data.rb"
require "amber/data/string_data.rb"
require "amber/model.rb"
require "amber/switch.rb"
require "amber/switch/content"
require "amber/switch/content/text"
require "amber/switch/content/form_data"
require "amber/switch/content/json"
require "amber/view.rb"
require "amber/view/json.rb"
require "amber/switch/request.rb"
require "amber/switch/request/get"
require "amber/switch/request/post"
require "amber/switch/response.rb"
require "benchmark"