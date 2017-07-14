class Amber::Server
  attr_accessor :port, :host, :base

  def initialize(port = 3001, host = '127.0.0.1')
    @port = port
    @host = host
    @server_socket
    @server_address
    @fd_set = []
  end
  
  def prepare
    @server_socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
    @server_address = Socket.sockaddr_in(@port, @host)

    @server_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
    @server_socket.bind(@server_address)
    @server_socket.listen(5)

    @fd_set << @server_socket
  end

  def start
    loop {
      fd_items = IO.select(@fd_set, [], [], 5)

      if fd_items.is_a?(Array)
        readable_items = fd_items.first
        readable_items.each do |socket|
          self.communicate(socket)
        end
      end
    }
  end

  def communicate(socket)
    if socket == @server_socket
      begin
        client_socket, client_address = @server_socket.accept_nonblock
        @fd_set << client_socket
      rescue IO::WaitReadable, Errno::EINTR
        retry
      end
      
    else
      @fd_set.delete(socket)
      task = Fiber.new {
        self.transaction(socket)
      }
      task.resume
    end
  end

  def transaction(socket)
    http_request = Amber::Http::Request.new(socket)
    http_response = Amber::Http::Response.new(socket)

    if http_request.receive
      time = Time.new
      time_string = time.strftime("%Y-%m-%d %H:%M:%S")
      STDOUT.puts "#{time_string} #{http_request.method} #{http_request.url}"
      begin
        if (path = @base.route.find(http_request.url)) && path.can_call?
          if path.method == http_request.method
            result = path.callback.call http_request
            case result
            when Amber::View
              http_response.status = result.code.to_s
              http_response.header = result.header
              http_response.content_type = result.content.type
              http_response.body = result.content.body
            when String
              http_response.status = "200"
              http_response.body = result
            else
              http_response.status = "500"
              http_response.body = "<html><h1>Server Internal Error</h1></html>"
            end
          else
            http_response.status = "301"
            http_response.body = "<html><h1>Moved Permanently</h1></html>"
          end
        else
          http_response.status = "404"
          http_response.body = "<html><h1>Not Found</h1></html>"
        end
      rescue Exception => e
        STDOUT.puts e
      end
    else
      http_response.status = "400"
      http_response.body = "<html><h1>Bad Request</h1></html>"
    end

    http_response.send

    socket.close
  end
end

require "socket"
require "fiber"

