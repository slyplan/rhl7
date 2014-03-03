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

      segment = new(raw_items, delims)
      segment.send :set_name, seg_name
      segment
    end

    def initialize(fields = [], delims = RHL7::Delimiter)
      @attrs = fields
      @delimiters = delims
    end

    def [](idx)
      array_idx = idx - 1
      raise RHL7::InvalidAttribute.new("There isn't attribute with index #{idx} in segment #{name}")  unless valid_attr_index?(idx)
      @attrs[array_idx]
    end

    def []=(idx, val)
      array_idx = idx - 1
      raise RHL7::InvalidAttribute.new("There isn't attribute with index #{idx} in segment #{name}")  unless valid_attr_index?(idx)
      @attrs[array_idx] = val
    end

    def to_s
      raise RHL7::InvalidSegment.new("Undefined segment name")  if @name.nil?
      [name, attrs[0..(attrs.rindex { |f| !f.nil? })]].flatten.join(@delimiters.element)
    end

    def valid_attr_index?(idx)
      idx > 0
    end

    private

    def set_name(seg)
      @name = seg.to_sym
    end

  end
end