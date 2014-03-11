module RHL7
  module Segment
    class APR < RHL7::Segment::Base

      attribute :time, type: :SCV, multiple: true # Time Selection Criteria 
      attribute :resource, type: :SCV, multiple: true # Resource Selection Criteria 
      attribute :location, type: :SCV, multiple: true # Location Selection Criteria 
      attribute :slot_spacing # Slot Spacing Criteria
      attribute :filler_override # Filler Override Criteria

    end
  end
end
