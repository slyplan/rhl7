module RHL7
  module Message

    def self.parse(msg)
      pure = msg.strip
      #raise RHL7::MissingSegment.new(:MSH) unless pure.start_with?("MSH")
      delim = RHL7::Delimiter.extract_from(msg)
      raw_segments = pure.split(RHL7::Delimiter.segment)
      parsed_segments = raw_segments.map do |str| 
        seg = RHL7::Segment.parse(str, delim)
      end
      get_message_class.new(parsed_segments, delim)
    end

    def self.get_message_class
      RHL7::AbstractMessage
    end

  end
end