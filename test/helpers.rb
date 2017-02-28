require "uuidtools"

def write_disk(res, path)
  f = File.new(path, "wb")
  f.write(res.body)
  f.close()
end

def make_path(type)
  uuid = UUIDTools::UUID.random_create.to_s
  path = uuid + '.' + type
  return path
end
