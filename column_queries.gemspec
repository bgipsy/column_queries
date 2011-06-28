Gem::Specification.new do |s|
  s.name        = "column_queries"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Serge Balyuk"]
  s.email       = ["serge@complicated-simplicity.com"]
  s.homepage    = "http://github.com/bgipsy/column_queries"
  s.summary     = "extensions for ActiveRecord PostgreSQL adapter with pg gem"
  s.description = "faster select_values implementation for ActiveRecord with PostgreSQL pg gem"
  
  s.required_rubygems_version = ">= 1.3.7"
  
  s.add_development_dependency "rspec", "~> 2.5.0"
  
  s.add_runtime_dependency "activerecord", "~> 3.0.4"
  s.add_runtime_dependency "pg", "~> 0.11.0"
  
  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
end
