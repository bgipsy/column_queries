class PostgresDatabase
  
  TEST_DB = {
    :username => 'postgres',
    :adapter => 'postgresql',
    :encoding => 'unicode',
    :database => 'column_queries_test',
    :username => 'postgres'
  }
  
  def self.prepare_database
    ActiveRecord::Base.establish_connection(TEST_DB.merge(:database => 'postgres'))
    ActiveRecord::Base.connection.drop_database(TEST_DB[:database])
    ActiveRecord::Base.connection.create_database(TEST_DB[:database], TEST_DB)
    ActiveRecord::Base.establish_connection(TEST_DB)
    CreateTestSchema.migrate(:up)
  end
  
  def self.establish_connection
    ActiveRecord::Base.establish_connection(TEST_DB)
  end
  
end

class CreateTestSchema < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string     :title
      t.float      :price
      t.text       :description
      t.timestamps
    end
    
    create_table :comments do |t|
      t.references :book
      t.text       :body
      t.timestamps
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
