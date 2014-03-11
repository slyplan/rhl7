module RHL7
  module Segment

    def self.parse(str, delims)
      seg_name = extract_name(str)
      seg_class = segment_class(seg_name)
      seg = seg_class.new(delims)
      seg.parse str
      seg
    end

    def self.segment_defined?(name)
      RHL7::Segment.const_defined?(name)
    end

    def self.segment_class(name)
      if segment_defined?(name)
        RHL7::Segment.const_get(name)
      else
        RHL7::AbstractSegment
      end
    end

    def self.extract_name(str)
      str.strip[0..2].upcase.to_sym
    end

  end
end