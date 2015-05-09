require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    # ...
  end

  def table_name
    # ...
  end
end

class BelongsToOptions < AssocOptions
  # name is name of associations
  def initialize(name, options = {})
    self.class_name = options[:class_name]
    self.foreign_key = options[:foreign_key]
    self.primary_key = options[:primary_key]

    self.class_name= name.to_s.camelcase if class_name.nil?
    self.foreign_key= "#{name}_id".to_sym if foreign_key.nil?
    self.primary_key= :id if primary_key.nil?
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
   self.class_name = options[:class_name]
   self.foreign_key = options[:foreign_key]
   self.primary_key = options[:primary_key]

    if class_name.nil?
      self.class_name = "dude"
    end

# 8 methods
# bye
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    # ...
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable
  include Associatable
end
