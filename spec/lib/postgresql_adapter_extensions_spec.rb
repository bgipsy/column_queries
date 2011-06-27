require 'spec_helper'

describe ColumnQueries::PostgreSQLAdapterExtensions do
  
  include Generators
  
  before :all do
    generate_books 1..20
  end
  
  it "should return array of ints" do
    result = Book.connection.select_int_values("SELECT id FROM books ORDER BY id")
    result.should == (1..20).to_a
  end
  
  it "should return array for each column" do
    comment_ids, book_ids = Book.connection.select_columns_as_int_arrays("SELECT id, book_id FROM comments WHERE book_id=10")
    book = Book.find(10)
    
    book_ids.should == [10] * book.comments.count
    comment_ids.should =~ book.comment_ids
  end
  
  it "should return 0 for NULL values" do
    comment = Comment.first
    Comment.create!(:body => 'another comment')
    Comment.create!(:body => 'yet another comment')
    
    book_ids = Comment.connection.select_int_values("SELECT book_id FROM comments WHERE book_id IS NULL OR id=#{comment.id}")
    
    book_ids.should =~ [0, 0, comment.id]
  end
  
end
