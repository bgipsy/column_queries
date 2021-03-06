require 'spec_helper'

describe ColumnQueries::RealtionExtensions do
  
  before :each do
    Book.delete_all
    @books = []
    @books << Book.create!(:title => 'Book 1', :description => 'Lorem ipsum ' * 100, :price_cents =>  495)
    @books << Book.create!(:title => 'Book 2', :description => 'Lorem ipsum ' * 100, :price_cents =>  999)
    @books << Book.create!(:title => 'Book 3', :description => 'Lorem ipsum ' * 100, :price_cents => 1999)
    @books << Book.create!(:title => 'Book 4', :description => 'Lorem ipsum ' * 100, :price_cents =>  nil)
  end
  
  describe "to_int_array" do
    it "should work for scopes" do
      Book.scoped.to_int_array(:id).should == @books.map(&:id)
    end
  
    it "should work with named scopes" do
      Book.pricy.to_int_array(:id).should == @books.select {|b| b.price_cents.to_i >= 1000}.map(&:id)
    end
  
    it "should work with dynamic scopes" do
      Book.scoped_by_price_cents(999).to_int_array(:id).should == [@books[1].id]
      Book.where('price_cents = 999').to_int_array(:id).should == [@books[1].id]
    end
  
    it "should work without arguments given .select() scope" do
      Book.select(:price_cents).to_int_array.should == @books.map {|b| b.price_cents.to_i}
    end
  end
  
  describe "to_columns_as_int_arrays" do
    it "should work for scopes" do
      ids, price_cents = Book.scoped.to_columns_as_int_arrays(:id, :price_cents)
      ids.should == @books.map(&:id)
      price_cents.should == @books.map {|b| b.price_cents.to_i}
    end
  
    it "should work with named scopes" do
      ids, price_cents = Book.pricy.to_columns_as_int_arrays(:id, :price_cents)
      ids.should == @books.select {|b| b.price_cents.to_i >= 1000}.map(&:id)
      price_cents.should == [1999]
    end
  
    it "should work with dynamic scopes" do
      ids, price_cents = Book.scoped_by_price_cents(999).to_columns_as_int_arrays(:id, :price_cents)
      ids.should == [@books[1].id]
      price_cents.should == [999]
    end
  
    it "should work without arguments given .select() scope" do
      ids, price_cents = Book.select([:id, :price_cents]).to_columns_as_int_arrays
      ids.should == @books.map(&:id)
      price_cents.should == @books.map {|b| b.price_cents.to_i}
    end
  end
  
  describe "to_int_hash" do
    it "should work for scopes" do
      prices = Book.scoped.to_int_hash(:id, :price_cents)
      prices.keys.should =~ @books.map(&:id)
      prices.values.should =~ @books.map {|b| b.price_cents.to_i}
      prices[@books[0].id].should == 495
      prices[@books[1].id].should == 999
    end
    
    it "should convert NULL values to 0s" do
      prices = Book.scoped.to_int_hash(:id, :price_cents)
      prices[@books[3].id].should == 0
    end
    
    it "should work with named scopes" do
      prices = Book.pricy.to_int_hash(:id, :price_cents)
      prices.should == {@books[2].id => 1999}
    end
  
    it "should work with dynamic scopes" do
      prices = Book.scoped_by_price_cents(999).to_int_hash(:id, :price_cents)
      prices.should == {@books[1].id => 999}
    end
  end
  
  describe "to_int_groups" do
    before :each do
      Comment.delete_all
      @books.each do |book|
        3.times { Comment.create!(:book => book, :body => 'Lorem Ipsum ' * 10) }
      end
    end
    
    it "should work for scopes" do
      books_comments = Comment.scoped.to_int_groups(:book_id, :id)
      books_comments.keys.should =~ @books.map(&:id)
      @books.each do |book|
        books_comments[book.id].should =~ book.comment_ids
      end
    end
    
    it "should work with named scopes" do
      books_comments = Comment.for_pricy_books.to_int_groups(:book_id, :id)
      books_comments.keys.should == [@books[2].id]
      books_comments.values.first.should =~ @books[2].comment_ids
    end
    
    it "should work with dynamic scopes" do
      books_comments = Comment.where("book_id IN (SELECT id FROM books WHERE price_cents IS NULL)").to_int_groups(:book_id, :id)
      books_comments.keys.should == [@books[3].id]
      books_comments.values.first.should =~ @books[3].comment_ids
    end
  end
  
end
