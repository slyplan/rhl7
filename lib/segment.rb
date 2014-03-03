module RHL7
  module Segment

    def self.parse(seg, delimiters = nil)
      pure = seg.strip
      seg_name = pure[0..2].upcase.to_sym
      segment_class = get_segment_class(seg_name)
      segment_class.parse(pure, delimiters)
    end

    def self.get_segment_class(seg)
      if RHL7::Segment.const_defined?(seg)
        RHL7::Segment.const_get(seg)
      else
        RHL7::AbstractSegment
      end
    end

  end
end