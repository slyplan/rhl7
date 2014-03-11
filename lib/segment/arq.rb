module RHL7
  module Segment
    class ARQ < RHL7::Segment::Base

      attribute :placer_id # Placer Appointment ID 
      attribute :filler_id # Filler Appointment ID 
      attribute :occurrence_num # Occurrence Number 
      attribute :placer_group_num # Placer Group Number 
      attribute :schedule_id # Schedule ID
      attribute :request_event_reason # Request Event Reason 
      attribute :app_reason # Appointment Reason
      attribute :app_type # Appointment Type
      attribute :app_duratuin # Appointment Duration
      attribute :app_duratuin_units # Appointment Duration Units 
      attribute :requested_datetime, type: :DR # Requested Start Date/Time Range
      attribute :priority # Priority-ARQ
      attribute :repeating # Repeating Interval
      attribute :repeating_duration # Repeating Interval Duration
      attribute :placer_person # Placer Contact Person
      attribute :placer_phone # Placer Contact Phone Number
      attribute :placer_address # Placer Contact Address
      attribute :placer_location # Placer Contact Location
      attribute :entered_by_person # Entered By Person
      attribute :entered_by_phone # Entered By Phone Number
      attribute :entered_by_location # Entered By Location
      attribute :parent_placer_id # Parent Placer Appointment ID
      attribute :parent_filler_id # Parent Filler Appointment ID
      attribute :placer_order_num # Placer Order Number
      attribute :filler_order_num # Filler Order Number

    end
  end
end
