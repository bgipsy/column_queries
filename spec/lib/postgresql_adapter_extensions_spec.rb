require 'spec_helper'

describe ColumnQueries::PostgreSQLAdapterExtensions do
  
  before :each do
    Book.delete_all
    @books = []
    @books << Book.create!(:title => 'Book 1', :description => 'Lorem ipsum ' * 100, :price_cents =>  495)
    @books << Book.create!(:title => 'Book 2', :description => 'Lorem ipsum ' * 100, :price_cents =>  999)
    @books << Book.create!(:title => 'Book 3', :description => 'Lorem ipsum ' * 100, :price_cents => 1999)
    @books << Book.create!(:title => 'Book 4', :description => 'Lorem ipsum ' * 100, :price_cents =>  nil)
  end
  
  it "should return array of ints" do
    result = Book.connection.select_int_values("SELECT id FROM books ORDER BY id")
    result.should == @books.map(&:id)
  end
  
  it "should return array for each column" do
    book_ids, price_cents = Book.connection.select_columns_as_int_arrays("SELECT id, price_cents FROM books ORDER BY id")
    book_ids.should == @books.map(&:id)
    price_cents.should == @books.map {|b| b.price_cents.to_i}
  end
  
  it "should return 0 for NULL values" do
    price_cents = Book.connection.select_int_values("SELECT price_cents FROM books WHERE price_cents IS NULL OR price_cents < 500")
    price_cents.should =~ [0, 495]
  end
  
end
