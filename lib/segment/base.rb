module RHL7
  module Segment
    class Base < RHL7::AbstractSegment

      def self.inherited(subclass)
        subclass.class_eval do 
          @attr_hash = {}
          @attr_idx = 1
        end
      end

      def self.attr_hash
        @attr_hash
      end

      def self.attr_idx
        @attr_idx
      end

      def self.attribute(attr_name, options = {})
        attr_name = attr_name.to_sym
        raise InvalidAttribute.new("Already defined attribute #{attr_name} in segment #{self.name}")  if @attr_hash.has_key?(attr_name)
        raise InvalidAttribute.new("Couldn't define attribute with name #{attr_name}")  if self.instance_methods.include?(attr_name) || self.instance_methods.include?("#{attr_name}=".to_sym)
        default_options = {:type => :ST, :optional => true, :default => nil}
        opt = default_options.merge(options.select{|k| k.has_key?(default_options)})
        opt[:idx] = @attr_idx
        self.class_eval <<-END
          def #{attr_name}(val = nil)
            self.[]=(#{@attr_idx}, val)  unless val.nil?
            self.[](#{@attr_idx})
          end

          def #{attr_name}=(val)
            self.[]=(#{@attr_idx}, val)
          end
        END
        @attr_idx += 1
        @attr_hash[attr_name] = opt
      end

      def initialize(fields = nil, delims = RHL7::Delimiter)
        raise RHL7::InvalidSegment.new("Couldn't initialize Base segment")  if self.class.name == "RHL7::Segment::Base"
        @name = self.class.name.split("::").last.upcase.to_sym  if @name.nil?
        if fields.nil?
          fill_attrs(default_attrs)
        elsif fields.kind_of?(Array)
          @attrs = fields
        elsif fields.kind_of?(Hash)
          fill_attrs(fields)
        else
          raise RHL7::InvalidSegment.new("Invalid attributes")
        end
        @delimiters =  delimiters
      end

      def attr_hash
        self.class.attr_hash
      end

      def attr_idx
        self.class.attr_idx
      end

      def [](idx)
        if idx.is_a?(Symbol)
          raise RHL7::InvalidAttribute.new("There isn't attribute with index #{idx} in segment #{name}")  unless @attr_hash.has_key?(idx)
          array_idx = attr_hash[idx][:idx]
        else
          array_idx = idx
        end
        super(array_idx)
      end

      def []=(idx, val)
        if idx.is_a?(Symbol)
          raise RHL7::InvalidAttribute.new("There isn't attribute with index #{idx} in segment #{name}")  unless @attr_hash.has_key?(idx)
          array_idx = attr_hash[idx][:idx]
        else
          array_idx = idx
        end
        super(array_idx, val)
      end

      def valid_attr_index?(idx)
        idx > 0 || attr_idx < idx
      end

      def fill_attrs(hsh)
        hsh.each do |field, val|
          self.[]=(field, val)
        end
      end

      def default_attrs
        res = []
        attr_hash.each_value do |att|
          res[att[:idx]] = att[:default]
        end
      end

    end
  end
end