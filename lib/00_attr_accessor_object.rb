class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method(name) do
        get_name = "@#{name}"
        instance_variable_get(get_name)
      end
      set_met = "#{name}="
      define_method(set_met) do |obj|
        name_set = "@#{name}"
        instance_variable_set(name_set, obj)
      end
    end
    # ...
  end
end
