source 'http://rubygems.org'
gemspec

group :development do
  gem 'jeweler'
  gem 'bundler'
  gem 'overcommit' # syntax error

  gem 'yajl-ruby', require: 'yajl/json_gem' # C-based JSON

  gem 'method_profiler'
  gem 'rack-timer', require: false
  gem 'ruby-prof', require: false

  gem 'rdoc'
end

group :development, :test do
  gem 'rspec'
  gem 'webmock'
  gem 'simplecov', require: false # code coverage tool
end

group :development, :metric_fu do
  gem 'rubocop' # ruby style guide enforcer
  gem 'cane'    # code quality threshold analyzer

  # code smells analyzer, for example:
  #   low cohesion (feature envy and utility functions)
  #   control coupling, nested iterators
  gem 'reek'

  gem 'flog'    # Assignments, Branches, Calls metrics
  gem 'saikuro' # Cyclomatic complexity analyzer
  gem 'roodi'   # Ruby Object Oriented Design Inferometer
end

group :development, :should_be_or_is_core do
  gem 'did_you_mean'       # make suggestions
  gem 'pry-byebug'         # debugger
  gem 'pry-bond'           # auto-competion in the debugger
  gem 'awesome_print'      # pretty output
  gem 'interactive_editor' #
end
