require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  # sanitization can't be done in a from clause
  # table_name method will alway return a table name
  def self.columns
    result = DBConnection.execute2(<<-SQL  )
      SELECT *
      FROM #{table_name}
    SQL
    result[0].map(&:to_sym)
  end

  # must use @ symbol.
  def self.finalize!
    columns.each do |column|
      define_method("#{column}=") do |arg|
        attributes[column] = arg
      end

      # because we're never storing the data in the variable,
      # it's stored in the attr hash. thus, won't work:
      # instance_variable_get("@#{column}")

      define_method(column) do
        attributes[column]
      end
    end
  end

  def self.table_name=(table_name)
    # @table_name = table_name
    instance_variable_set(:@table_name, table_name)
  end
  # no benefit to using #i_v_s because we know what the method name is going to be.
  # it's not dynamic

  def self.table_name
    @table_name.nil? ? self.name.tableize : @table_name
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # ...
  end

  def attributes
    @attributes ||= {}  # lazy initialization of attrs
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
