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

  # because we're never storing the data in the variable,
  # it's stored in the attr hash. thus, won't work:
  # instance_variable_get("@#{column}")

# define_method

  def self.finalize!
    columns.each do |column|
      define_method("#{column}=") do |arg|
        attributes[column] = arg
      end

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

  # Use ordinary Ruby string interpolation (#{whatevs}) for this;
  # SQL will only let you use ? to interpolate values, not table or column names.

  def self.all
    result = DBConnection.execute(<<-SQL )
            SELECT *
            FROM #{table_name};
            SQL
    parse_all(result)  # Hash object will inherit sqlobj initialize method
  end

  def self.parse_all(results)
    results.map do |object|
      self.new(object)
    end
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id )
    SELECT *
    FROM #{table_name}
    WHERE id = ? ;
    SQL
    result.map{|obj| self.new(obj) }.pop
  end

  # send to self i.e a cat object
  # method called on object to which we will send the argument
  # send converts string args to symbols

  # Human will inherit from SQLObject

  def initialize(params = {})
    valid_attributes = self.class.columns
    params.each do |attr_name, value|
      if valid_attributes.include?(attr_name.to_sym)
        self.send("#{attr_name}=".to_sym, value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}  # lazy initialization of attrs
  end

  # [1,2,3].variable will look for variable method
  def attribute_values
    self.class.columns.map{|attr| self.send(attr) }
  end

  def insert
    col_names = self.class.columns
    question_marks = ["?"] * (col_names.length)
    DBConnection.execute(<<-SQL, *attribute_values )
    INSERT INTO #{self.class.table_name} (#{col_names.join(", ")})
    VALUES
      (#{question_marks.join(", ")});
    SQL
    self.id= DBConnection.last_insert_row_id
    # we need to update our attributes hash
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
