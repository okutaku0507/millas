$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "millas/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "millas"
  s.version     = Millas::VERSION
  s.authors     = ["Takuya Okuhara"]
  s.email       = ["okutaku0507@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Millas."
  s.description = "TODO: Description of Millas."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"

  s.add_development_dependency "sqlite3"
end
