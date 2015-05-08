class AttrAccessorObject

  def self.my_attr_accessor(*names)
    names.each do |name|
      # getter
      define_method(name) do
         instance_variable_get("@#{name}")
      end
      
      # setter
      define_method("#{name}=".to_sym) do |arg|
        instance_variable_set("@#{name}", arg)
      end

    end
  end



end


# class#define_method(symbol) { block } → symbol

# obj#instance_variable_get(symbol) → obj
# Returns the value of the given instance variable, or nil if the instance variable is not set.
#
# obj#instance_variable_set(symbol, obj)
# Sets the instance variable names by symbol to object

# self.name=('david')
