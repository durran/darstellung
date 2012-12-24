require "bundler"
Bundler.setup

require "rake"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "darstellung/version"

task :gem => :build
task :build do
  system "gem build darstellung.gemspec"
end

task :install => :build do
  system "sudo gem install darstellung-#{Darstellung::VERSION}.gem"
end

task :release => :build do
  system "git tag -a v#{Darstellung::VERSION} -m 'Tagging #{Darstellung::VERSION}'"
  system "git push --tags"
  system "gem push darstellung-#{Darstellung::VERSION}.gem"
  system "rm darstellung-#{Darstellung::VERSION}.gem"
end

RSpec::Core::RakeTask.new("spec") do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
