module Generators
  
  def generate_books(id_range)
    id_range.each do |i|
      book = Book.new(:title => 'Lorem ipsum', :description => 'Lorem ipsum ' * 100, :price => 9.99)
      book.id = i
      book.save!
      
      generate_comments(book, 3)
    end
    Book.connection.reset_pk_sequence!('books')
  end
  
  def generate_comments(book, ncomments)
    ncomments.times do
      Comment.create!(:book => book, :body => 'troll it!' * 10)
    end
  end
  
end
