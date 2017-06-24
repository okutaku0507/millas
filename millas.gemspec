$:.push File.expand_path("../lib", __FILE__)
require "millas/version"

Gem::Specification.new do |spec|
  spec.name        = "millas"
  spec.version     = Millas::VERSION
  spec.authors     = ["Takuya Okuhara"]
  spec.email       = ["work.okutaku0507@gmail.com"]
  spec.homepage    = "https://github.com/okutaku0507"
  spec.summary     = "Simple and dispersed cache mechanism."
  spec.description = "Simple and dispersed cache mechanism."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "activesupport"
  spec.add_dependency "dalli"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
