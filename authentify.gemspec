# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'authentify/version'

REQUIREMENTS = {
  runtime: {
    savon: ['~> 2.9.0'],
    iso: ['~> 0.2.1'],
    activesupport: ['~> 4.2.0'],
    'mime-types' => ['~> 1.25.1'], # wasabi-3.3.x (< 2.0.0), mechanize-2.7.3 (~> 2.0)
    'rest-client' => ['~> 1.8.0']},
  development: {
    bundler: ['~> 1.3'],
    rake: ['>= 10.4.2'],
    sqlite3: ['>= 1.3.7'],
    database_cleaner: ['~> 1.3.0'],
    :'pry-byebug' => ['~> 3.3.0'],
    rspec: ['~> 3.1.0']}
}.freeze

Gem::Specification.new do |spec|
  spec.name        = 'authentify'
  spec.version     = Authentify::VERSION
  spec.authors     = ['Paul Belt']
  spec.email       = %w(paul.belt+authentify@gmail.com)
  spec.license     = 'GPL'
  spec.homepage    = 'http://github.com/belt/authentify'
  spec.summary     = 'Out of band authentication for ruby projects'
  spec.description = 'Out-of-band authentication is the use of two separate networks working simultaneously to authenticate a user. In Authentify’s case, this means using the phone to verify the identity of the user involved in a web transaction.'

  spec.rubyforge_project = 'authentify'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) {|fn| File.basename fn}
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = %w(lib)

  spec.required_ruby_version = Gem::Requirement.new('>= 2.2.3')
  spec.required_rubygems_version = Gem::Requirement.new('>= 0') if spec.respond_to? :required_rubygems_version=

  [:runtime, :development].each do |mode|
    REQUIREMENTS[mode].each do |req, ver|
      if spec.respond_to? :specification_version
        spec.specification_version = 3
        if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
          if mode == :runtime
            spec.add_runtime_dependency req.to_s, ver
          else
            spec.add_development_dependency req.to_s, ver
          end
        else
          spec.add_dependency req.to_s, ver
        end
      else
        spec.add_dependency req.to_s, ver
      end
    end
  end
end
