module RHL7
  class Scheme

    def self.messages
      @messages
    end

    def self.scheme_exists?(msg, evt = nil)
      @messages.has_key?(msg.to_sym) && (evt.nil? ? true : @messages[msg.to_sym].has_key?(evt.to_sym))
    end

    def self.get_scheme(msg, evt)
      return nil  unless scheme_exists?(msg, evt)
      evt.nil? ? @messages[msg.to_sym] : @messages[msg.to_sym][evt.to_sym]
    end

    @messages = {}
    @subject = nil

    def self.draw(msg, &block)
      if block_given?
        msg_name = msg
        @messages[msg_name] = {} if @messages[msg_name].nil?
        @subject = @messages[msg_name]
        yield
        @subject = nil
      else
        raise RHL7::InvalidScheme.new("Scheme should be drawn")
      end
    end

    def self.event(evt, &block)
      if block_given?
        evt_name = evt
        if @subject[evt_name].nil?
          @subject[evt_name] = {}
          old_subject = @subject
          @subject = @subject[evt_name]
          yield
          @subject = old_subject
        else
          raise RHL7::InvalidScheme.new("Event #{evt_name} already exists in #{msg_name}")
        end
      else
        raise RHL7::InvalidScheme.new("Event should be drawn")
      end
    end

    def self.segment(seg, options, &block)
      default_opts = {:exists => true, :children => nil}
      @subject[seg] = default_opts.merge(options)
      if block_given?
        @subject[seg][:children] = {}
        old_subject = @subject
        @subject = @subject[seg][:children]
        yield
        @subject = old_subject
      end
    end

    # def initialize(msg, evt)
    #   @msg = msg
    #   @evt = evt
    #   raise RHL7::InvalidScheme.new("Scheme #{[msg, evt].compact.join("_")} not drawn")  unless RHL7::Scheme.scheme_exists?(@msg, @evt)
    # end

  end
end