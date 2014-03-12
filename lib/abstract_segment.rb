module RHL7
  class AbstractSegment < RHL7::AbstractObject

    object_delimiter :element

    attr_reader :name
    attr_accessor :scope

    def to_s
      raise RHL7::InvalidSegment.new("Undefined segment name")  if name.nil?
      [name, super].join(delimiter)
    end

    def set_name(nm)
      @name = nm.upcase.to_sym  if name.nil?
    end

    def load_from_string(str)
      attrs = split_by_delimiter(str)
      set_name attrs[0]
      attrs[1..-1].each_with_index do |att, index|
        self[index + 1] = att
      end
    end

    def load_from_array(arr)
      set_name attrs[0]
      arr[1..-1].each_with_index do |att, index|
        self[index + 1] = att
      end
    end

  end
end