class Amber::Http::Request < Amber::Http
  attr_reader :method, :url, :query, :protocol, :body
  
  GET = "GET"
  POST = "POST"
  PUT = "PUT"
  DELETE = "DELETE"

  def initialize(socket)
    super

    @url = ""
    @query = {}
    @body = {}
  end
  
  def receive
    unless self.receive_request
      STDERR.puts "Bad request"
      return false
    end

    self.receive_header

    # p @header

    if @header.has_key?("Content-Length")
      content_length = @header["Content-Length"].to_i

      if content_length > 0
        self.receive_body(content_length)
      end
    end

    # p @body_raw_data

    # p @body

    return true
  end
  
  def receive_request
    last_token = ""
    data = ""

    Timeout::timeout(30) {
      while buffer = @socket.recv_nonblock(1)
        if last_token == "\r" && buffer == "\n"
          break
        end

        data << buffer
        last_token = buffer
      end
    }
    
    self.parse_request(data)
  end

  def parse_request(data)
    request_info = data.split(' ')

    if request_info.length == 3
      case request_info[0]
      when GET
        @method = GET
      when POST
        @method = POST
      when PUT
        @method = PUT
      when DELETE
        @method = DELETE
      else
        return false
      end

      self.parse_url request_info[1]
      @protocol = request_info[2]
    end

    return true
  end

  def parse_url(url)
    if url.include? "?"
      url_info = url.split "?"
      @url = url_info[0]
      if url_info.length > 1
        self.parse_query url_info[1]
      end
      return
    end
    @url = url
  end

  def parse_query(query_string)
    query_info = query_string.split "&"
    query_info.each do |query_info_item|
      query_item = query_info_item.split "="
      if query_item.length == 2
        query_item_key = query_item[0]
        query_item_value = query_item[1]
        @query[query_item_key] = query_item_value
      end
    end
  end

  def receive_header
    loop { break unless receive_header_item }
  end

  def receive_header_item
    last_token = ""
    data = ""

    while buffer = @socket.recv_nonblock(1)
      if last_token == "\r" && buffer == "\n"
        break
      end

      data << buffer
      last_token = buffer
    end

    if data == "\r"
      return false
    end

    self.parse_header_item(data.chomp)
  end

  def parse_header_item(data)
    header_item = data.split(": ")

    if header_item.length == 2
      @header[header_item[0]] = header_item[1]
    end

    return true
  end

  def receive_body(size)
    data = @socket.recv(size)
    self.parse_body(data)
  end

  def parse_body(data)
    @body_raw_data = data

    if @header.has_key?("Content-Type")
      content_type = @header["Content-Type"]

      if content_type.include? "application/x-www-form-urlencoded"
        self.parse_form_body(data)
      elsif content_type.include? "multipart/form-data"
        content_type_info = content_type.split("; ")
        content_type_info.each do |info|
          if info.include? "boundary"
            boundary_info = info.split('=')

            if boundary_info.length == 2
              boundary = boundary_info[1]
              self.parse_multipart_form_body(boundary, data)
            end
          end
        end
      end
    end
  end

  def parse_form_body(data)
    form_items = data.split('&')

    form_items.each do |item|
      item_info = item.split('=')
      if item_info.length == 2
        @body[item_info[0]] = item_info[1]
      end
    end
  end

  def parse_multipart_form_body(boundary, data)
    offset = 0
    boundary_string = "--#{boundary}"

    while offset = data.index(boundary_string, offset)
      next_offset = data.index(boundary_string, offset + 1)

      unless next_offset
        break
      end

      data_part = data.slice(offset + boundary_string.length + 2, next_offset - offset - boundary_string.length - 4)
      self.parse_form_part(data_part)

      offset = next_offset
    end
  end

  def parse_form_part(data)
    first_of_break = data.index("\r\n\r\n")
    unless first_of_break === nil
      content_info_data = data.slice(0, first_of_break)
      content_info_data = content_info_data.gsub("\r\n", "; ")
      content_info = content_info_data.split("; ")
      content_disposition = ""
      content_name = ""

      content_info.each do |info|
        if info.include? "Content-Disposition"
          info_array = info.split(': ')
          content_disposition = info_array[1] if info_array.length == 2

        elsif info.include? "name="
          info_array = info.split('=')
          content_name = info_array[1] if info_array.length == 2
        end
      end

      content_body = data.slice(first_of_break + 4, data.length - 4 - first_of_break - 2)

      unless content_name.empty?
        @body[content_name] = content_body
      end
    end
  end
end

require "timeout"
