# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => error
  $stderr.puts error.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit error.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see
  # http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'authentify'
  gem.homepage = 'http://github.com/belt-ascendlearning/authentify'
  gem.license = 'MIT'
  gem.summary = %(Out of band authentication for ruby projects})
  gem.description = 'Out-of-band authentication is the use of two separate ' \
                    'networks working simultaneously to authenticate a user. ' \
                    'In Authentify’s case, this means using the phone to ' \
                    'verify the identity of the user involved in a web ' \
                    'transaction.'

  gem.email = 'paul.belt+authentify@gmail.com'
  gem.authors = ['Paul Belt', 'Abhidarshan Reddy']
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['spec'].execute
end

require 'reek/rake/task'
Reek::Rake::Task.new do |t|
  t.fail_on_error = true
  t.verbose = false
  t.source_files = 'lib/**/*.rb'
end

require 'roodi'
require 'roodi_task'
RoodiTask.new do |t|
  t.verbose = false
end

task default: :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "authentify #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
