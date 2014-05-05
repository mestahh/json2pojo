require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :build => :spec do
  system "rm -rf json2pojo-*.gem"
  system "gem build Gemspec"
end

task :publish => :build do
  system "gem push json2pojo-*.gem"
end
