require 'ostruct'

module RHL7

  class MissingSegment < StandardError
    def initialize(seg)
      super("Missing required segment #{seg}")
    end
  end

  class InvalidMessage < StandardError
  end

  class InvalidObject < StandardError
  end

  class InvalidScheme < StandardError
  end

  class InvalidSegment < StandardError
  end

  class InvalidAttribute < StandardError
  end

end

require './lib/scheme.rb'
require './lib/delimiter.rb'
require './lib/attribute.rb'
require './lib/defenition.rb'
require './lib/abstract_object.rb'
require './lib/abstract_message.rb'
require './lib/abstract_segment.rb'
require './lib/abstract_data_type.rb'
require './lib/defineable.rb'
require './lib/message.rb'
require './lib/segment.rb'
require './lib/data_type.rb'
require './lib/segment/base.rb'
Dir[File.dirname(__FILE__) + '/lib/segment/*.rb'].each { |file| require file }
