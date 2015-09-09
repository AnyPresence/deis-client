Gem::Specification.new do |s|
  s.name  = 'deis-client'
  s.version = '0.0.3'
  s.date = '2015-09-09'
  s.summary = "Deis REST operations in a Ruby gem."
  s.description = "Deis Platform REST (V1.5) client for Ruby."
  s.authors = ["AnyPresence"]
  s.email = 'engineering@anypresence.com'
  s.files = `git ls-files -z`.split("\0")
  s.homepage = 'http://rubygems.org/gems/deis_client'
  s.license = 'MIT'
  s.add_dependency('rest-client', '>= 1.6.7', '< 2.0')
  s.required_ruby_version = '>= 1.9.3'
end
