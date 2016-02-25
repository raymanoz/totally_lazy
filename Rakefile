# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'

# require 'jeweler'
# Jeweler::Tasks.new do |gem|
#   gem.name = 'totally_lazy'
#   gem.homepage = 'http://github.com/raymanoz/totally_lazy'
#   gem.license = 'Apache 2.0'
#   gem.summary = 'Port of java functional library totally lazy to ruby'
#   gem.description = 'Port of java functional library totally lazy to ruby'
#   gem.email = 'rbarlow@raymanoz.com'
#   gem.authors = ['Raymond Barlow']
# end
# Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

desc 'run rspec guard'
task :guard do
  system('bundle exec guard')
end

desc 'rebuild gem'
task :re do
  system('gem uninstall totally_lazy && rake build && gem install -l pkg/totally_lazy-dev.build' + 'dev.build' + '.gem')
end


