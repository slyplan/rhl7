module RHL7
  module Segment
    class Base < RHL7::AbstractSegment

      include RHL7::Attributes

      def initialize(fields = nil, delims = RHL7::Delimiter)
        @name = self.class.name.split("::").last.upcase.to_sym  if name.nil?
        super(fields, delims)
      end

    end
  end
end