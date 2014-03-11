module RHL7
  module DataType
    #HL7 datetime datatype
    class DTM < RHL7::DataType::Base

      attribute :datetime

      def self.matchstr
        '%Y%m%d%H%M%S'
      end

      # def self.parse(timestr, delims = RHL7::Delimiter)
      #   timestr = timestr.first  if timestr.is_a?(Array)
      #   return nil  if timestr.nil?
      #   super(DateTime.strptime(timestr, matchstr), delims)
      # end

      def to_datetime
        DateTime.strptime(datetime, self.class.matchstr)
      end

    end
  end
end