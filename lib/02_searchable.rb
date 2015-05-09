require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params = {})
    where, vals = [], []
    params.each do |k, v|
      where << "#{k} = ?"
      vals << v
    end
    result = DBConnection.execute(<<-SQL, *vals)
      SELECT *
      FROM #{table_name}
      WHERE #{where.join(" AND ")}
    SQL
    result.map{|obj| self.new(obj)}
  end
end

class SQLObject
  extend Searchable
end
