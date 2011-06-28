class Book < ActiveRecord::Base
  
  scope :pricy, where('price_cents >= 1000')
  
end
