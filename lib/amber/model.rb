class Amber::Model

  def initialize
    @data = {}
    @data["id"] = Amber::Data::IntegerData.new
  end

  def [](key)
    if @data.has_key? key
      return @data[key]
    end
  end

  def has_key?(key)
    @data.has_key? key
  end

  def []=(key, value)
    if value.is_a? Amber::Data
      @data[key] = value
    end
  end

  def keys
    @data.keys
  end

  def pack(map = nil)
    data = {}
    if map.is_a? Hash
      map.each do |key, value|
        if @data.has_key? key
          data_item = @data[key]
          data[value] = data_item.value
        end
      end
    else
      @data.each do |key, value|
        data[key] = value.value
      end
    end
    data
  end

  def unpack(data, map = nil)
    if data.is_a? Hash
      if map.is_a? Hash
        map.each do |key, value|
          if @data.has_key?(key) && data.has_key?(value)
            data_item = @data[key]
            data_item.value = data[value]
          end
        end
      else
        data.each do |key, value|
          if @data.has_key? key
            data_item = @data[key]
            data_item.value = data[key]
          end
        end
      end
    end
  end

  def struct(map = nil, name_only = false)
    struct = {}
    if map.is_a? Hash
      map.each do |key, value|
        if @data.has_key? key
          data_item = @data[key]
          if name_only
            struct[value] = data_item.class.to_s.match('\w+$').to_s
            next
          end
          struct[value] = data_item.class.to_s
        end
      end
    else
      @data.each do |key, value|
        if name_only
          struct[key] = value.class.to_s.match('\w+$').to_s
          next
        end
        struct[key] = value.class.to_s
      end
    end
    struct
  end
end