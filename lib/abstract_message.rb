module RHL7
  class AbstractMessage
    
    def initialize(segments = [], delimiters = RHL7::Delimiter)
      @segments = segments
      @delimiters =  delimiters
    end

    def [](idx)
      @segments[idx]
    end

    def []=(idx, val)
      @segments[idx] = val
    end

    def to_s
      @segments[0..(@segments.rindex { |f| !f.nil? })].join(@delimiters.segment)
    end

  end
end