module RHL7
  module Segment
    class Base < RHL7::AbstractSegment

      extend RHL7::Defineable

      def initialize(delims)
        @name = self.class.name.split("::").last.upcase.to_sym  if name.nil?
        super(delims)
      end

      def set_name(nm)
      end

    end
  end
end