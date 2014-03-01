module RHL7

  class MissingSegment < StandardError
    def initialize(seg)
      super("Missing required segment #{seg}")
    end
  end

  class UnknownSegment < StandardError
  end

end

require './lib/delimiter.rb'
require './lib/message.rb'
require './lib/segment.rb'
require './lib/message/base.rb'
require './lib/segment/base.rb'