module RHL7
  module Message

    def self.parse(msg)
      pure = msg.strip
      raise RHL7::MissingSegment.new(:MSH) unless pure.start_with?("MSH")

      delim = RHL7::Delimiter.new(:element => pure[3], :item => pure[4])
      raw_segments = pure.split(delim.segment)
      parsed_segments = raw_segments.map { |str| RHL7::Segment.parse(str, delim) }
      get_message_class.new(parsed_segments, delim)
    end

    def self.get_message_class
      Class.new(RHL7::Message::Base)
    end

  end
end