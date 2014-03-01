#Rename in AbstractSegment

module RHL7
  module Segment
    class Base

      attr_reader :items
      attr_reader :name

      def initialize(items = [], delimiters = RHL7::Delimiter)
        @name =  find_out_segment_name
        @items = items
        @delimiters =  delimiters
      end

      def set_name(seg)
        @name = seg.to_sym
        self
      end

      def [](idx)
        @items[idx]
      end

      def []=(idx, val)
        @items[idx] = val
      end

      def to_s
        raise RHL7::UnknownSegment.new("Undefined segment name")  if @name.nil?
        [name, items[0..(items.rindex { |f| !f.nil? })]].flatten.join(@delimiters.element)
      end

      private

      def find_out_segment_name
        return @name  if @name.nil?
        unless self.class != Class 
          self.class.name.split("::").last.to_sym  
        else
          nil
        end
      end

    end

  end
end