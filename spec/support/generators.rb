module Generators
  
  def generate_books(id_range)
    id_range.each do |i|
      book = Book.new(:title => 'Lorem ipsum', :description => 'Lorem ipsum ' * 100, :price => 9.99)
      book.id = i
      book.save!
    end
    Book.connection.reset_pk_sequence!('books')
  end
  
end
