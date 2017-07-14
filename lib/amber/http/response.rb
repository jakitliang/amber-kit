class Amber::Http::Response < Amber::Http
  attr_reader :status, :header, :content_type, :body

  TEXT_CONTENT = "text/plain"
  HTML_CONTENT = "text/html"
  JSON_CONTENT = "application/json"

  def initialize(socket)
    super

    @status_table = {
      "100" => "Continue",
      "200" => "OK",
      "300" => "Multiple Choices",
      "301" => "Moved Permanently",
      "400" => "Bad Request",
      "401" => "Unauthorized",
      "403" => "Forbidden",
      "404" => "Not Found",
      "500" => "Internal Server Error",
      "502" => "Bad Gateway",
      "503" => "Service Unavailable"
    }

    @mime_table = [
      TEXT_CONTENT,
      HTML_CONTENT,
      JSON_CONTENT
    ]

    @status = "200"
    @header = {}
    @content_type = HTML_CONTENT
    @body = ""
  end
  
  def send
    data = create_status_line
    data << "Server: Amber/0.0.1\r\n"
    @header.each do |key, value|
      data << "#{key}: #{value}\r\n"
    end
    data << "Content-Type: #{@content_type}\r\n"
    data << "Content-Length: #{@body.length}\r\n\r\n"
    data << @body

    @socket.sendmsg data, 0
  end

  def create_status_line
    status_line = "HTTP/1.1 "
    status_line << @status
    status_line << ' '
    status_line << @status_table[@status]
    status_line << "\r\n"
    status_line
  end

  def status=(status)
    @status = status if @status_table.has_key?(status)
  end

  def header=(header)
    if header.is_a? Hash
      header.each do |key, value|
        @header[key] = value
      end
    end
  end

  def content_type=(content_type)
    @content_type = content_type if @mime_table.include?(content_type)
  end
  
  def body=(body)
    if body.is_a? String
      @body = body.bytes.to_a.pack("C*")
    end
  end
end