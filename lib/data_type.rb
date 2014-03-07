module RHL7
  module DataType

    def self.parse(elem, hl7_type, delimiters = RHL7::Delimiter)
      return nil  if elem.nil?
      raw_element = elem.split(delimiters.item).map{|r| r  unless r.empty? }
      elem_class = hl7_type.nil? && raw_element.size <= 1 ? RHL7::DataType::ST : get_data_type_class(hl7_type)
      elem_class.new(raw_element, delimiters)
    end

    def self.get_data_type_class(hl7_type)
      if !hl7_type.nil? && RHL7::DataType.const_defined?(hl7_type)
        RHL7::DataType.const_get(hl7_type)
      else
        RHL7::AbstractDataType
      end
    end

  end
end