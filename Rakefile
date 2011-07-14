require 'rubygems'
require 'bundler'

Bundler.setup
Bundler::GemHelper.install_tasks

require 'active_record'
require 'active_record/base'
require 'rspec/core/rake_task'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w[--color]
end

task :prepare_db do
  require './spec/support/db.rb'
  PostgresDatabase.prepare_database
end

task :benchmark => [:prepare_db] do
  require './spec/support/db'
  require './spec/support/models'
  require './spec/support/benchmarks'
  require 'column_queries'
  Benchmarks.run
end

task :default => [:prepare_db, :spec]
