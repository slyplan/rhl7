module RHL7
  class Delimiter

    def self.segment
      "\r"
    end

    def self.element
      "|"
    end

    def self.item
      "^"
    end

    def self.extract_from(message)
      pure = message.strip
      RHL7::Delimiter.new(:element => pure[3], :item => pure[4])
    end

    attr_reader :segment
    attr_reader :element
    attr_reader :item

    def initialize(delimiters = {})
      @segment = delimiters[:segment] || self.class.segment
      @element = delimiters[:element] || self.class.element
      @item    = delimiters[:item] || self.class.item
    end

  end
end