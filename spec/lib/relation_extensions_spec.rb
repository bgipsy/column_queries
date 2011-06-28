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
  
  it "should provide to_int_array method for scopes" do
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
