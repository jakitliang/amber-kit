class Amber::Switch
  def query(request)
    if request.is_a? Amber::Switch::Request
      result = nil
      case request
      when Amber::Switch::Request::Get
        result = self.request(request.url, request.method, request.header)
      when Amber::Switch::Request::Post
        body = request.content.is_a?(Amber::Switch::Content) ? request.content.body : nil
        result = self.request(request.url, request.method, request.header, body)
      end
      if result
        response = Amber::Switch::Response.new
        response.status = result["status"]
        response.header = result["header"]
        response_content_type = result["content_type"].is_a?(Array) ? result["content_type"].first : result["content_type"].to_s
        case response_content_type
        when Amber::Switch::Content::JSON_CONTENT
          response.content = Amber::Switch::Content::Json.new
          response.content.body = result["body"]
        else
          response.content = Amber::Switch::Content::Text.new
          response.content.body = result["body"]
        end
        return response
      end
    end

    p "#{request} should be an instance of Amber::Switch::Request"
    return
  end

  def request(url, method, header = {}, body = nil)
    request = nil
    uri = URI(url)
    response = {
      "status" => false,
      "code" => 400,
      "content_type" => nil,
      "header" => {},
      "body" => nil
    }
    case method
    when Amber::Switch::Request::GET_METHOD
      request = Net::HTTP::Get.new uri
    when Amber::Switch::Request::POST_METHOD
      request = Net::HTTP::Post.new uri
    end
    if request
      header.each do |key, value|
        request[key] = value
      end
      request.body = body if body
      result = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(request)
      end

      case result
      when Net::HTTPSuccess
        response["status"] = true
        response["code"] = result.code.to_i
        response["content_type"] = result.content_type
        response["header"] = result.to_hash
        response["body"] = result.body
      end
    end
    response
  end
end

require "net/http"