class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method(name) do
        name
      end

      define_method(name=) do
        name = name
      end

    end
  end
end
