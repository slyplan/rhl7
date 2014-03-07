module RHL7
  module Attributes

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def inherited(subclass)
        subclass.class_eval do 
          @attr_hash = {}
          @attr_idx = 1
        end
        super(subclass)
      end

      def attr_hash
        @attr_hash
      end

      def attr_idx
        @attr_idx
      end

      def attribute(attr_name, options = {})
        attr_name = attr_name.to_sym
        raise InvalidAttribute.new("Already defined attribute #{attr_name} in #{object_type} #{self.name}")  if @attr_hash.has_key?(attr_name)
        raise InvalidAttribute.new("Couldn't define attribute with name #{attr_name}")  if self.instance_methods.include?(attr_name) || self.instance_methods.include?("#{attr_name}=".to_sym)
        default_options = {:type => :ST, :optional => true, :default => nil}
        opt = default_options.merge(options.select{|k| default_options.has_key?(k)})
        opt[:idx] = @attr_idx
        self.class_eval <<-END
          def #{attr_name}(val = nil)
            set_attr(#{@attr_idx - 1}, val)  unless val.nil?
            get_attr(#{@attr_idx - 1})
          end

          def #{attr_name}=(val)
            set_attr(#{@attr_idx - 1}, val)
          end
        END
        @attr_idx += 1
        @attr_hash[attr_name] = opt
      end

    end

    def attr_hash
      self.class.attr_hash
    end

    def attr_idx
      self.class.attr_idx
    end

    def has_field?(field_name)
      attr_hash.has_key?(field_name.to_sym)
    end

    private

    def real_index(field)
      return super(field)  unless field.is_a?(Symbol)
      raise RHL7::InvalidAttribute.new("Undefined attribute #{field} in #{object_type} #{name}")  unless has_field?(field)
      attr_hash[field.to_sym][:idx]
    end

    def get_type_by(real_idx)
      get_attribute_defenition(real_idx + 1)[:type]
    end

    def get_attribute_defenition(idx)
      if idx.is_a?(Symbol)
        attr_hash[idx]
      else
        raise RHL7::InvalidAttribute.new("There isn't attribute with index #{idx} in #{object_type} #{name}")  unless valid_attr_index?(idx)
        attr_hash.values.select { |v| v[:idx] == idx }.first
      end
    end

    def attrs_from_hash(hash)
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