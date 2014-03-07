module RHL7
  class AbstractSegment < RHL7::AbstractObject

    object_type :segment
    object_delimiter :element

    def self.parse(seg, delims)
      raw_items = seg.split(delims.send(self.get_object_delimiter))
      seg_name = raw_items.delete_at(0).upcase.to_sym

      if self.name != "RHL7::Segment::#{seg_name}" && self.name != "RHL7::AbstractSegment"
        raise RHL7::InvalidSegment.new("Couldn't parse segment #{seg_name} as #{self.name}")
      end

      segment = new(raw_items.map{|r| r  unless r.empty? }, delims)
      segment.instance_variable_set :@name, seg_name
      segment
    end

    def to_s
      raise RHL7::InvalidSegment.new("Undefined segment name")  if name.nil?
      [name, super].join(delimiter)
    end

  end
end