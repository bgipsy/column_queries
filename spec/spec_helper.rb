require './lib/column_queries'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir['./spec/support/**/*.rb'].each {|f| require f}

RSpec.configure do |config|
  
  config.before :all do
    PostgresDatabase.establish_connection
  end
  
end
