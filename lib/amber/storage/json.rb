class Amber::Storage::Json < Amber::Storage
  def initialize(file_path)
    @file_path = file_path
  end

  def fetch
    data = []
    if raw_data = self.read_file
      data = self.deserialize(raw_data)
    end
    data.first
  end

  def fetch_all
    data = []
    if raw_data = self.read_file
      data = self.deserialize(raw_data)
    end
    data
  end

  def save(data)
    if File.exist? @file_path
      file = File.open(@file_path, "w")
      file.puts self.serialize(data)
      file.close
    end
  end

  def update(data)
    if raw_data = self.read_file
      origin_data = self.deserialize(raw_data)
      new_data = []

      if data.is_a? Array
        origin_data.each do |item|
          new_item = item
          data.each do |data_item|
            if data_item["id"] == item["id"]
              new_item = data_item
            end
          end
          new_data.push(new_item)
        end
      else
        origin_data.each do |item|
          new_item = item
          if data["id"] == item["id"]
            new_item = data
          end
          new_data.push(new_item)
        end
      end

      self.save(new_data)
    end
  end

  def delete(data)
    if raw_data = self.read_file
      origin_data = self.deserialize(raw_data)
      new_data = []

      if data.is_a? Array
        origin_data.each do |item|
          retain = true
          data.each do |data_item|
            if data_item["id"] == item["id"]
              retain = false
            end
          end
          new_data.push(item) if retain
        end
      else
        origin_data.each do |item|
          retain = true
          if data["id"] == item["id"]
            retain = false
          end
          new_data.push(item) if retain
        end
      end

      self.save(new_data)
    end
  end

  def serialize(data)
    begin
      data = [data] unless data.is_a? Array
      JSON.generate(data)
    rescue Exception => e
      p e
    end
  end

  def deserialize(data)
    begin
      JSON.parse(data)
    rescue Exception => e
      p e
    end
  end

  def read_file
    if File.exist? @file_path
      file = File.open(@file_path)
      raw_data = file.read
      raw_data = "[]" if raw_data.empty?
      file.close
      return raw_data
    end
  end
end

require "json"