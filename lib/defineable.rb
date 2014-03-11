module RHL7
  module Defineable

    def self.extended(klass)
      klass.set_defenition
    end

    def attribute(field, options = {})
      opt = { :type => :ST }.merge(options)
      defenition.add field, opt
      add_accessors(field)
    end

    def add_accessors(field)
      idx = defenition[field].index
      self.class_eval <<-END
          def #{field}(val = nil)
            self.[]=(#{idx}, val)  unless val.nil?
            self.[](#{idx})
          end

          def #{field}=(val)
            self.[]=(#{idx}, val) 
          end
        END
    end

  end
end