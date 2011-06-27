require 'active_record'
require 'active_record/base'
require 'active_record/connection_adapters/postgresql_adapter'

module ColumnQueries
  require 'column_queries/postgresql_adapter_extensions'
  require 'column_queries/relation_extensions'
end
