module RHL7
  class AbstractSegment

    attr_reader :attrs
    attr_reader :name
    attr_reader :delimiters

    def self.parse(seg, delims)
      raw_items = seg.split(delims.element)
      seg_name = raw_items.delete_at(0).upcase.to_sym

      if self.name != "RHL7::Segment::#{seg_name}" && self.name != "RHL7::AbstractSegment"
        raise RHL7::InvalidSegment.new("Couldn't parse segment #{seg_name} as #{self.name}")
      end

      segment = new(raw_items.map{|r| r  unless r.empty? }, delims)
      segment.send :set_name, seg_name
      segment
    end

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
      raise RHL7::InvalidSegment.new("Undefined segment name")  if name.nil?
      [name, attrs[0..(attrs.rindex { |f| !f.nil? })]].flatten.join(delimiters.element)
    end

    private

    def get_attr(idx)
      @attrs[idx]
    end

    def set_attr(idx, val)
      @attrs[idx] = RHL7::DataType.parse(val, get_type_by(idx), delimiters)
    end

    def get_type_by(real_idx)
      nil
    end

    def real_index(idx)
      raise RHL7::InvalidAttribute.new("There isn't attribute with index #{idx} in segment #{name}")  unless valid_attr_index?(idx)
      idx.to_i - 1
    end

    def fill_attrs(from_obj)
      meth = "attrs_from_#{from_obj.class.name.split("::").last.downcase}".to_sym
      raise RHL7::InvalidSegment.new("Couldn't extract attributes from #{from_obj.class.name}")  unless respond_to?(meth, true)
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

    def set_name(seg)
      @name = seg.to_sym
    end

  end
end