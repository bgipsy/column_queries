require 'spec_helper'

describe ColumnQueries::PostgreSQLAdapterExtensions do
  
  include Generators
  
  before :each do
    generate_books 1..1000
  end
  
  it "should return array of ints" do
    result = Book.connection.select_int_values("SELECT id FROM books ORDER BY id")
    result.should == (1..1000).to_a
  end
  
end
