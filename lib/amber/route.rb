class Amber::Route
  attr_reader :root
  
  def initialize
    @root = Amber::RoutePath.new
  end

  def map(url, method = nil, &callback)
    layers = self.parse_url(url)

    if layers.length > 0
      layers.delete ""
      current_layer = @root

      layers.each do |layer|
        if layer == layers.last
          if current_layer.child.has_key? layer
            path = current_layer.child[layer]
            path.callback = callback
            path.method = method if method
            next
          end
          
          new_path = Amber::RoutePath.new
          new_path.callback = callback
          new_path.method = method if method

          current_layer.add_child(layer, new_path)
        else
          if current_layer.child.has_key? layer
            current_layer = current_layer.child[layer]
            next
          end

          new_path = Amber::RoutePath.new
          current_layer.add_child(layer, new_path)
          current_layer = new_path
        end
      end
    else
      @root.callback = callback
    end
  end

  def find(url)
    layers = self.parse_url(url)
    current_layer = @root

    if layers.length > 0
      layers.delete ""
      layers.each do |layer|
        if current_layer.child.has_key? layer
          current_layer = current_layer.child[layer]
        else
          return nil
        end
      end
    end

    current_layer
  end

  def parse_url(url)
    url.split('/')
  end
end