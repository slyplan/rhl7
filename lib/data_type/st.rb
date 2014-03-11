module RHL7
  module DataType
    #HL7 string datatype
    class ST < String

      attr_reader :delimiters

      def initialize(delims)
        @delimiters = delims
        @elem_escape_char = "/H/"
        @item_escape_char = "/E/"
        super("")
      end

      def parse(obj)
        obj = obj.gsub(@elem_escape_char, delimiters.element)
        obj = obj.gsub(@item_escape_char, delimiters.item)
        clear
        concat obj
      end

      def to_s
        str = String.new(self.gsub(delimiters.element, @elem_escape_char).gsub(delimiters.item, @item_escape_char))
        str.to_s
      end


    end
  end
end