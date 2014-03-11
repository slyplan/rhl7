module RHL7
  class AbstractObject

    def self.set_defenition(def_obj = nil)
      @defenition = def_obj || RHL7::Defenition.new(self)
    end

    def self.defenition
      @defenition
    end

    def self.inherited(subclass)
      # new_defenition = self.defenition.nil? ? RHL7::Defenition.new(self) : self.defenition.dup
      # new_defenition.defenition_for(subclass)
      subclass.set_defenition # new_defenition
      subclass.object_delimiter self.get_object_delimiter
    end

    def self.object_delimiter(sym)
      @object_delimiter = sym
    end

    def self.get_object_delimiter
      @object_delimiter || RHL7::Delimiter.segment
    end

    attr_reader :delimiters
    attr_reader :delimiter
    attr_reader :values
    attr_reader :defenition

    def initialize(delims)
      puts "Initialized: #{self.class.name}"
      @values = []  if @values.nil?
      @delimiters = delims
      @delimiter = delimiters.send self.class.get_object_delimiter
      set_defenition
    end

    def [](idx)
      get_value(defenition[idx].real_index)
    end

    def []=(idx, val)
      res = defenition[idx].parse val, delimiters
      add_value res
    end

    def to_s
      values.empty? ?
      "" : 
      values[0..(values.rindex { |f| !f.nil? })].join(delimiter)
    end

    def parse(obj)
      parse_handler = "load_from_#{obj.class.name.split("::").last.downcase}".to_sym
      raise RHL7::InvalidObject.new("Couldn't parse #{obj.class.name} as #{self.class.name}")  unless respond_to?(parse_handler)
      self.send parse_handler, obj
      self
    end

    def load_from_string(str)
      attrs = split_by_delimiter(str)
      attrs.each_with_index do |att, index|
        self[index + 1] = att
      end
    end

    def load_from_array(arr)
      arr.each_with_index do |att, index|
        self[index + 1] = att
      end
    end

    private

    def split_by_delimiter(str)
      str.strip.split(delimiter).map{|r| r  unless r.empty? }
    end

    def set_defenition
      defenition_object = self.class.defenition.dup
      defenition_object.defenition_for(self)
      defenition_object.freeze
      @defenition = defenition_object
    end

    def get_value(idx)
      @values[idx]
    end

    def set_value(idx, val)
      @values[idx] = val
    end

    def add_value(val)
      if val.respond_to?(:"_index_")
        idx = val._index_
        val.instance_eval { undef :"_index_"}
        set_value(idx, val)
      else
        raise RHL7::InvalidObject.new("Couldn't add value")  
      end
    end

  end
end