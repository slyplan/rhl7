module RHL7

  class MissingSegment < StandardError
    def initialize(seg)
      super("Missing required segment #{seg}")
    end
  end

  class InvalidSegment < StandardError
  end

  class InvalidAttribute < StandardError
  end

end

require './lib/delimiter.rb'
require './lib/message.rb'
require './lib/segment.rb'
require './lib/abstract_message.rb'
require './lib/abstract_segment.rb'
require './lib/segment/base.rb'
Dir[File.dirname(__FILE__) + '/lib/segment/*.rb'].each { |file| require file }
