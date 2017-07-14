class Amber::Storage::RemoteJson < Amber::Storage
  def initialize(url)
    @uri = URI.parse(url)
    @status = false
    @data = {}
  end

  def query(data)
    self.request({"token" => "", "data" => data})
  end

  def request(body = nil)
    request = Net::HTTP::Post.new(@uri)
    # request.body = body if body
    response = nil
    @status = false
    @data = {}
    result = Net::HTTP.start(@uri.hostname, @uri.port) do |http|
      response = http.request(request)
    end

    case result
    when Net::HTTPSuccess
      info = self.deserialize(result.body)
      if info.is_a? Hash
        if info.has_key?("status") && info["status"] == 1
          @status = true
          info_data = {}
          info_data = info["data"] if info.has_key?("data")
          if info_data.is_a?(Array) || info_data.is_a?(Hash)
            @data = info_data
          end
        else
          @status = false
        end
      end
    end
  end

  def serialize(data)
    data_string = ""
    begin
      data = [data] unless data.is_a? Array
      data_string = JSON.generate(data)
    rescue Exception => e
      p e
    end
    data_string
  end

  def deserialize(data)
    data_struct = nil
    begin
      data_struct = JSON.parse(data)
    rescue Exception => e
      p e
    end
    data_struct
  end

  def pack(map)
    data = nil
    if map.is_a? Hash
      if @data.is_a? Hash
        data = {}
        map.each do |key, value|
          if @data.has_key? key
            data[value] = @data[key]
          else
            data[value] = nil
          end
        end
      elsif @data.is_a? Array
        data = []
        @data.each do |result_data_item|
          if result_data_item.is_a? Hash
            data_item = {}
            map.each do |key, value|
              if @result_data_item.has_key? key
                data_item[value] = @result_data_item[key]
              else
                data_item[value] = nil
              end
            end
            data.push data_item
          end
        end
      end
    end
    data
  end

  def unpack(data, map)
    # map.each do |key, value|
    #   if data.is_a? Hash
        
    #   end
    # end
  end
end

require "json"
require "net/http"