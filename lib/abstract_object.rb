module RHL7
  class AbstractObject

    attr_reader :attrs
    attr_reader :name
    attr_reader :delimiters
    attr_accessor :delimiter
    attr_reader :object_type

    def self.inherited(subclass)
      subclass.object_type self.get_object_type
      subclass.object_delimiter self.get_object_delimiter
    end

    def self.object_type(sym)
      @object_type = sym
    end

    def self.get_object_type
      @object_type || :abstract
    end

    def self.object_delimiter(sym)
      @object_delimiter = sym
    end

    def self.get_object_delimiter
      @object_delimiter || RHL7::Delimiter.segment
    end

    def initialize(fields = nil, delims = RHL7::Delimiter)
      raise RHL7::InvalidObject.new("Couldn't initialize Base #{object_type}")  if self.class.name.downcase == "rhl7::#{object_type}::base"
      fields = fields || default_attrs
      delimiter = delims.send self.class.get_object_delimiter
      @object_type = self.class.get_object_type
      @attrs = []  if @attrs.nil?
      @delimiters = delims
      fill_attrs(fields)
    end

    def [](idx)
      get_attr(real_index(idx))
    end

    def []=(idx, val)
      set_attr(real_index(idx), val)
    end

    def to_s
      attrs[0..(attrs.rindex { |f| !f.nil? })].join(delimiter)
    end

    private

    def get_attr(idx)
      @attrs[idx]
    end

    def set_attr(idx, val)
      @attrs[idx] = RHL7::DataType.parse(val, get_type_by(idx), delimiters)
    end

    def real_index(idx)
      raise RHL7::InvalidAttribute.new("There isn't attribute with index #{idx} in #{object_type} #{name}")  unless valid_attr_index?(idx)
      idx.to_i - 1
    end

    def get_type_by(real_idx)
      nil
    end

    def fill_attrs(from_obj)
      meth = "attrs_from_#{from_obj.class.name.split("::").last.downcase}".to_sym
      raise RHL7::InvalidObject.new("Couldn't extract attributes from #{from_obj.class.name}")  unless respond_to?(meth, true)
      self.send meth, from_obj
    end

    def attrs_from_array(arr)
      i = 0
      arr.each do |val|
        set_attr(i, val)
        i += 1 
      end
    end

    def valid_attr_index?(idx)
      limit = attr_idx.nil? ? true : attr_idx > idx
      idx > 0 && limit
    end

    def default_attrs
      []
    end

  end
end