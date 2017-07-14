Gem::Specification.new do |s|
  s.name = "amber-kit"
  s.version = "0.0.1"
  s.authors = ["Jakit"]
  s.date = "2017-06-03"
  s.summary = "A glitter network toolkit"
  s.description = "Useful network toolkit for create your application"
  s.email = "jakit_liang@outlook.com"
  s.files = [
    "Rakefile",
    "amber.gemspec",
    "bin/amber",
    "lib/amber.rb",
    "lib/amber/controller.rb",
    "lib/amber/data.rb",
    "lib/amber/data/array_data.rb",
    "lib/amber/data/date_data.rb",
    "lib/amber/data/float_data.rb",
    "lib/amber/data/integer_data.rb",
    "lib/amber/data/string_data.rb",
    "lib/amber/data_delegate.rb",
    "lib/amber/http.rb",
    "lib/amber/http/request.rb",
    "lib/amber/http/response.rb",
    "lib/amber/model.rb",
    "lib/amber/route.rb",
    "lib/amber/route_path.rb",
    "lib/amber/server.rb",
    "lib/amber/storage.rb",
    "lib/amber/storage/json.rb",
    "lib/amber/storage/remote_json.rb",
    "lib/amber/switch.rb",
    "lib/amber/switch/content.rb",
    "lib/amber/switch/content/form_data.rb",
    "lib/amber/switch/content/json.rb",
    "lib/amber/switch/content/text.rb",
    "lib/amber/switch/content_delegate.rb",
    "lib/amber/switch/request.rb",
    "lib/amber/switch/request/get.rb",
    "lib/amber/switch/request/post.rb",
    "lib/amber/switch/response.rb",
    "lib/amber/view.rb",
    "lib/amber/view/json.rb"
  ]
  s.executables << 'amber'
  s.require_paths = ["lib"]
  s.homepage = "http://pingz.org.cn/amber"
  s.license = "MIT"
end
