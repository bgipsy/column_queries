module ColumnQueries::RealtionExtensions
  def to_int_array(column = nil)
    relation = column.nil? ? self : select(column)
    @klass.connection.select_int_values(relation.arel.to_sql)
  end

  def to_columns_as_int_arrays(*columns)
    relation = columns.empty? ? self : select(columns)
    @klass.connection.select_columns_as_int_arrays(relation.arel.to_sql)
  end

  def to_int_groups(keys_column, values_column)
    keys, values = to_columns_as_int_arrays(keys_column, values_column)
    keys.zip(values).inject({}) do |hash, pair|
      value = hash[pair.first]
      if value
        value << pair.last
      else
        hash[pair.first] = [pair.last]
      end
      hash
    end
  end
  
  def to_int_hash(keys_column, values_column)
    keys, values = to_columns_as_int_arrays(keys_column, values_column)
    Hash[keys.zip(values)]
  end
end

ActiveRecord::Relation.send(:include, ColumnQueries::RealtionExtensions)
