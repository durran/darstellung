# encoding: utf-8
require "./lib/darstellung/version"

Gem::Specification.new do |s|
  s.name         = "darstellung"
  s.version      = Darstellung::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Durran Jordan"]
  s.email        = ["durran@gmail.com"]
  s.summary      = "Simple and fast representations for APIs in Ruby"
  s.description  = s.summary
  s.files        = Dir.glob("lib/**/*") + %w(README.md LICENSE Rakefile)
  s.require_path = "lib"
end
