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

version = "#{File.read('VERSION').to_s}.#{ENV['BUILD_NUMBER'].nil? ? 'devbuild' : ENV['BUILD_NUMBER'].to_s}"

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = 'totally_lazy'
  gem.version = version
  gem.homepage = 'http://github.com/raymanoz/totally_lazy'
  gem.license = 'Apache 2.0'
  gem.summary = 'A lazy FP library for Ruby'
  gem.description = 'Port of java functional library totallylazy to ruby'
  gem.email = 'rbarlow@raymanoz.com'
  gem.authors = ['Raymond Barlow', 'Kingsley Hendrickse']
  gem.required_ruby_version = '2.0.0'
end
Jeweler::RubygemsDotOrgTasks.new

desc 'rebuild gem'
task :re do
  system("gem uninstall totally_lazy && rake build && gem install -l pkg/totally_lazy-#{version}.gem")
end

