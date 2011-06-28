module ColumnQueries::RealtionExtensions
  def to_int_array(column = nil)
    relation = column.nil? ? self : select(column)
    @klass.connection.select_int_values(relation.arel.to_sql)
  end

  def to_columns_as_int_arrays(*columns)
    relation = columns.empty? ? self : select(columns)
    @klass.connection.select_columns_as_int_arrays(relation.arel.to_sql)
  end

  # the first column should correspond to keys, and the second one - to values
  def to_ids_hash(key_col, val_col)
    keys, vals = to_columns_as_int_arrays(key_col, val_col)
    hash = Hash.new
    vals.each_with_index do |val, idx|
      key = keys[idx].to_i
      hash[key] ||= Array.new
      hash[key] |= [val.to_i]
    end
    hash.default = []
    hash
  end
  
  def to_ints_hash(keys_column, values_column)
    keys, values = to_columns_as_int_arrays(keys_column, values_column)
    Hash[keys.zip(values)]
  end
end

ActiveRecord::Relation.send(:include, ColumnQueries::RealtionExtensions)
