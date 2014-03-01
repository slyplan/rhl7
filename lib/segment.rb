module RHL7
  module Segment

    def self.parse(seg, delimiters = RHL7::Delimiter)
      pure = seg.strip

      raw_items = pure.split(delimiters.element)
      seg_name = raw_items.delete_at(0).upcase.to_sym

      segment = get_segment_class(seg_name).new(raw_items, delimiters)
      segment.set_name(seg_name)
    end

    def self.get_segment_class(seg)
      if RHL7::Segment.const_defined?(seg)
        RHL7::Segment.const_get(seg)
      else
        Class.new(RHL7::Segment::Base)
      end
    end

  end
end