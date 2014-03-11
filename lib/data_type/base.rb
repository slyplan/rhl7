module RHL7
  module DataType
    class Base < RHL7::AbstractObject

      object_delimiter :item
      extend RHL7::Defineable

    end
  end
end