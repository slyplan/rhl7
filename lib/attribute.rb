module RHL7
  class Attribute

    attr_reader :name, :type, :optional, :default, :multiple, :index

    def initialize(options = {})
      @name = options[:name]
      @type = options[:type]
      @index = options[:index]
      @optional = options[:optional] || true
      @default = options[:default] || nil
      @multiple = options[:multiple] || false

      set_datatype_class      
    end

    def real_index
      @index - 1 
    end

    def multiple?
      @multiple
    end

    def optional?
      @optional
    end

    def mandatory?
      !@optional
    end

    # def get_value(klass)
    #   vals = klass.instance_variable_get :@values
    #   vals[real_index]
    # end

    # def set_value(klass, val)
    #   raise RHL7::InvalidAttribute.new("Attribute #{name} must be present")  if mandatory? && val.nil?
    #   val ||= default
    #   vals = klass.instance_variable_get :@values
    #   attr_class = datatype.new(klass.delimiters)
    #   if attr_class.to_s == val.class.name
    #     vals[real_index] = val
    #   else
    #     vals[real_index] = attr_class.parse val
    #   end
    #   klass.instance_variable_set :@values, vals
    # end

    def parse(obj, delims)
      obj ||= default
      raise RHL7::InvalidAttribute.new("Attribute #{name} must be present")  if mandatory? && obj.nil?
      if optional? && obj.nil?
        res_obj = nil
      elsif obj.class == datatype
        res_obj = obj
      else
        parsed_obj = datatype.new(delims)
        parsed_obj.as(type)  if multiple?
        parsed_obj.parse obj
        res_obj = parsed_obj
      end
      add_index_to_object(res_obj)
      res_obj
    end

    def datatype
      multiple_class || datatype_class
    end

    private 

    def set_datatype_class
      if datatype_defined?
        @datatype_class = type.nil? ? RHL7::AbstractDataType : RHL7::DataType.const_get(type)
      else
        raise RHL7::InvalidAttribute.new("Undefined datatype #{type}")
      end
    end

    def datatype_defined?
      return true  if type.nil?
      RHL7::DataType.const_defined?(type)
    end

    def datatype_class
      @datatype_class
    end

    def multiple_class 
      multiple? ? RHL7::DataType::Multiple : nil
    end

    def add_index_to_object(obj)
      unless obj.respond_to?("_index_".to_sym)
        obj.instance_eval <<-END
          def _index_
            #{real_index}
          end
        END
        true
      else
        false
      end
    end

  end
end