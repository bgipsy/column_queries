module ColumnQueries::PostgreSQLAdapterExtensions
  def select_int_values(sql)
    select_columns_as_int_arrays(sql).first
  end

  # column_values is quite fast method written in C provided by pg gem
  # which seems like what we need for fetching lenghty id arrays
  def select_columns_as_int_arrays(sql)
    result = execute(sql)
    (0...result.nfields).collect {|i| result.column_values(i).map {|j| j.to_i}}
  end
end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.send(:include, ColumnQueries::PostgreSQLAdapterExtensions)
