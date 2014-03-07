module RHL7
  class AbstractDataType

    attr_reader :attrs
    attr_reader :delimiters

    def initialize(fields = [], delims = RHL7::Delimiter)
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
      attrs[0..(attrs.rindex { |f| !f.nil? })].join(delimiters.item)
    end

    def name
      nm = self.class.name
      if nm == "RHL7::AbstractDataType"
        :abstract
      else
        nm.split("::").last.upcase.to_sym
      end
    end

    private

    def get_attr(idx)
      @attrs[idx]
    end

    def set_attr(idx, val)
      @attrs[idx] = RHL7::DataType.parse(val, get_type_by(idx), delimiters)
    end

    def real_index(idx)
      raise RHL7::InvalidAttribute.new("There isn't element with index #{idx} in datatype #{name}")  unless valid_attr_index?(idx)
      idx.to_i - 1
    end

    def get_type_by(real_idx)
      nil
    end

    def fill_attrs(from_obj)
      meth = "attrs_from_#{from_obj.class.name.split("::").last.downcase}".to_sym
      raise RHL7::InvalidSegment.new("Couldn't extract elements from #{from_obj.class.name}")  unless respond_to?(meth, true)
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
      idx > 0
    end

  end
end