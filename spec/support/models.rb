class Book < ActiveRecord::Base
  
  has_many :comments
  
  scope :pricy, where('price_cents >= 1000')
  
end

class Comment < ActiveRecord::Base
  
  belongs_to :book
  
  scope :for_pricy_books, lambda { where(:book_id => Book.pricy.select(:id).project) }
  
end
