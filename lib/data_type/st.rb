module RHL7
  module DataType
    class ST < String

      attr_reader :delimiters

      def initialize(str, delims = RHL7::Delimiter)
        @delimiters = delims
        str = str.join(delimiters.item) if str.is_a?(Array)
        @elem_escape_char = "/H/"
        @item_escape_char = "/E/"

        str = str.gsub(@elem_escape_char, delimiters.element)
        str = str.gsub(@item_escape_char, delimiters.item)
        super(str)
      end

      def to_s
        str = String.new(self.gsub(delimiters.element, @elem_escape_char).gsub(delimiters.item, @item_escape_char))
        str.to_s
      end


    end
  end
end