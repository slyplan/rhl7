module RHL7
  module Segment
    class MSH < RHL7::Segment::Base

      attribute :field_separator
      attribute :enc_chars
      attribute :sending_app
      attribute :sending_facility
      attribute :recv_app
      attribute :recv_facility
      attribute :time, type: :TS
      attribute :security
      attribute :message_type, type: :MSG, optional: false
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

      def to_s
       [name, values[1..(values.rindex { |f| !f.nil? })]].flatten.join(delimiter)
      end

      def load_from_string(str)
        attrs = split_by_delimiter(str)
        attrs[0] = delimiter
        attrs.each_with_index do |att, index|
          self[index + 1] = att
        end
      end

      def load_from_array(arr)
        arr[0] = delimiter
        arr.each_with_index do |att, index|
          self[index + 1] = att
        end
      end

      def before_assign(msg)
        msg.load_scheme(message_type.message_code, message_type.trigger_event)
      end

    end
  end
end