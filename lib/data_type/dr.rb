module RHL7
  module DataType
    #HL7 datetime datatype
    class DR < RHL7::DataType::Base

      attribute :from, type: :TS
      attribute :till, type: :TS

    end
  end
end