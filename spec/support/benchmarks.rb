require 'benchmark'

module Benchmarks
  
  extend self
  
  def active_record_find
    Book.find(:all).map {|b| b.id}
  end
  
  def active_record_select_values
    Book.connection.select_values('SELECT id FROM books').map {|i| i.to_i}
  end
  
  def relation_to_int_array
    Book.scoped.to_int_array(:id)
  end
  
  NSAMPLES = 50
  
  def run_sample(name, &block)
    puts "Benchmarking #{name}"
    # warm up
    3.times { yield }
    
    bm = Benchmark.realtime { NSAMPLES.times { yield } }
    puts "Time: #{'%0.3f' % bm}s #{'%0.4f' % (bm / NSAMPLES)}s per run"
  end
  
  def generate_books(id_range)
    id_range.each do |i|
      book = Book.new(:title => 'Lorem ipsum', :description => 'Lorem ipsum ' * 100, :price_cents => 999)
      book.id = i
      book.save!
    end
    Book.connection.reset_pk_sequence!('books')
  end
  
  def run
    puts "Test sample contains 20000 records"
    generate_books(1..20000)
    run_sample('find') { active_record_find }
    run_sample('select_values') { active_record_select_values }
    run_sample('to_int_array') { relation_to_int_array }
  end
  
end
