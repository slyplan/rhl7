module RHL7
  class AbstractDataType < RHL7::AbstractObject

    object_delimiter :item

    def []=(idx, val)
      set_value(defenition[idx].real_index, val)
    end

  end
end