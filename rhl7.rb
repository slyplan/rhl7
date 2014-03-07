module RHL7

  class MissingSegment < StandardError
    def initialize(seg)
      super("Missing required segment #{seg}")
    end
  end

  class InvalidObject < StandardError
  end

  class InvalidSegment < StandardError
  end

  class InvalidAttribute < StandardError
  end

end

require './lib/delimiter.rb'
require './lib/attributes.rb'
require './lib/abstract_object.rb'
require './lib/message.rb'
require './lib/segment.rb'
require './lib/data_type.rb'
require './lib/abstract_message.rb'
require './lib/abstract_segment.rb'
require './lib/abstract_data_type.rb'
require './lib/segment/base.rb'
require './lib/data_type/base.rb'
Dir[File.dirname(__FILE__) + '/lib/segment/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/lib/data_type/*.rb'].each { |file| require file }
