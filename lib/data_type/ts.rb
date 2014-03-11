module RHL7
  module DataType
    #HL7 datetime datatype
    class TS < RHL7::DataType::Base

      attribute :time, type: :DTM
      attribute :degree_of_precision

      def to_datetime
        time.to_datetime
      end

    end
  end
end