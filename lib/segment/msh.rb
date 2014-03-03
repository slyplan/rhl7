module RHL7
  module Segment
    class MSH < RHL7::Segment::Base

      attribute :field_separator
      attribute :enc_chars
      attribute :sending_app
      attribute :sending_facility
      attribute :recv_app
      attribute :recv_facility
      attribute :time
      attribute :security
      attribute :message_type
      attribute :message_control_id
      attribute :processing_id
      attribute :version_id
      attribute :seq
      attribute :continue_ptr
      attribute :accept_ack_type
      attribute :app_ack_type
      attribute :country_code
      attribute :charset
      attribute :principal_language_of_message
      attribute :alternate_character_set_handling_scheme
      attribute :message_profile_identifier

      def initialize(fields = nil, delims = RHL7::Delimiter)
        if fields.kind_of?(Array)
          fields.unshift(delims.element)
        end
        super(fields, delims)
      end

      def to_s
       [name, attrs[1..(attrs.rindex { |f| !f.nil? })]].flatten.join(attrs[0])
      end

    end
  end
end