module RHL7
  module DataType
    class SCV < RHL7::DataType::Base

      attribute :parameter_class
      attribute :parameter_value

    end
  end
end