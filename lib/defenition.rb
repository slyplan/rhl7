module RHL7
  class Defenition

    attr_reader :attributes

    def initialize(relation, default_attribute_type = nil)
      defenition_for(relation)
      @attributes = {}
      @symbolic_indexes = []
      @default_attr_type = default_attribute_type
      @index = 1
    end

    def add(field, options)
      options[:index] = @index
      options[:name] = field
      @attributes[field] = RHL7::Attribute.new(options)
      @symbolic_indexes[@index] = field
      @index += 1
      @attributes[field]
    end

    def [](idx)
      if attributes_defined?
        idx = get_name_by_index(idx)  if idx.kind_of?(Fixnum)
        get_field(idx.to_sym)
      else
        raise InvalidAttribute.new("Undefined attribute with index #{idx} for #{@rel.class.name}")  if !idx.kind_of?(Fixnum) && idx < 1
        RHL7::Attribute.new(:index => idx, :type => @default_attr_type)
      end
    end

    def attributes_defined?
      !@attributes.empty?
    end

    def defenition_for(klass)
      @rel = klass
    end

    # def get_value(idx)
    #   self.[](idx).get_value(@rel)
    # end

    # def set_value(idx, val)
    #   self.[](idx).set_value(@rel, val)
    # end

    private

    def get_field(field)
      @attributes[field]
    end

    def get_name_by_index(index)
      res = @symbolic_indexes[index]
      raise InvalidAttribute.new("Undefined attribute with index #{index} for #{@rel.class.name}")  if res.nil?
      res
    end

  end

end