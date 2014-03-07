module RHL7
  class AbstractDataType < RHL7::AbstractObject

    object_type :datatype
    object_delimiter :item

    def initialize(fields = nil, delims = RHL7::Delimiter)
      @name = self.class.name == "RHL7::AbstractDataType" ? :abstract_data_type : self.class.name.split("::").last.upcase.to_sym
      super(fields, delims)
    end

  end
end