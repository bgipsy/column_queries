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
  
    it "should work with names scopes" do
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
  
    it "should work with names scopes" do
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
  
end
