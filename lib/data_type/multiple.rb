module RHL7
  module DataType
    class Multiple < RHL7::AbstractObject

      object_delimiter :code

      def initialize(delims)
        @multiple_type = nil
        super(delims)
      end

      def as(tp)
        @multiple_type = tp
        set_defenition
      end

      def [](idx)
        if idx.is_a?(String)
          hsh_el = values.select { |el| el[1] == idx }.first
          hsh_el.nil? ? nil : hsh_el[2]
        else
          super(idx)
        end
      end

      private

      def set_defenition
        defenition_object = RHL7::Defenition.new(self, @multiple_type)
        defenition_object.freeze
        @defenition = defenition_object
      end

    end
  end
end