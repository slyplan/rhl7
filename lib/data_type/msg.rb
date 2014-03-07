module RHL7
  module DataType
    class MSG < RHL7::DataType::Base

      attribute :message_code
      attribute :trigger_event
      attribute :message_structure

    end
  end
end
