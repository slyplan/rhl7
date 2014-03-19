module RHL7
  class Message

    def self.parse(msg)
      pure = msg.strip
      #raise RHL7::MissingSegment.new(:MSH) unless pure.start_with?("MSH")
      delim = RHL7::Delimiter.extract_from(msg)
      message = new(delim)
      raw_segments = pure.split(delim.segment)
      raw_segments.each do |str| 
        parsed_segment = RHL7::Segment.parse(str, delim)
        message << parsed_segment
      end
      message
    end

    attr_reader :delimiters
    attr_reader :scheme
    attr_reader :segments
    attr_reader :name

    def initialize(delims)
      @name = "AbstractMessage"
      @assigning_counter = 0
      @segments = []
      @delimiters =  delims
      @scheme = nil
      @segments_order = []

      @current_scope = "main"
      @scope_stack = []
    end

    def assign(segment)
      segment.before_assign(self)  if segment.respond_to?(:before_assign)
      real_assign(segment)
      segment.after_assign(self)  if segment.respond_to?(:after_assign)
      next_segment
    end

    alias :<< :assign

    def load_scheme(msg, evt)
      @scheme = RHL7::Scheme.get_scheme(msg, evt)
      if scheme_defined?
        @name = [msg, evt].compact.join("_")  
        @segments_order = unpack(@scheme)
        puts "Unpacked defenition #{@segments_order.inspect}"
      end
    end

    def to_s
      segments.compact.join(@delimiters.segment)
    end

    def scheme_defined?
      !@scheme.nil?
    end

    #upgrade this
    def [](idx)
      seg_nm = idx.to_s[0..2].to_sym
      muli_idx = idx.to_s[3..-1]

      segs = segments_by_scope("main").select{ |s| s.name == seg_nm}
      if segs.empty?
        res = nil  
      elsif segs.size == 1
        res = segs.first
      else
        res = segs[muli_idx.to_i]
      end

      unless res.nil?
        seg_idx = @segments.find_index { |s| s == res}
        unless @segments_order[seg_idx].children.nil?
          hsh_res = {:self => res}
          @segments_order[seg_idx].children.keys.each_with_index do |seg_def, offset|
            hsh_res[seg_def] = segments[seg_idx + offset]
          end

          return hsh_res
        end
      end

      res
    end

    private

    def next_segment
      @assigning_counter += 1
    end

    def unpack(scheme_pattern, scope = "main")
      res = []
      scheme_pattern.each do |segment, defenition|
        res << OpenStruct.new(
          :name => segment,
          :scope => "main",
          :optional? => defenition[:optional],
          :required? => !defenition[:optional],
          :multiple? => defenition[:multiple],
          :single?   => !defenition[:multiple],
          :exists?   => defenition[:exists],
          :children  => defenition[:children],
        )
      end
      res
    end

    def defenition(idx = nil)
      if scheme_defined?
        index = idx || @assigning_counter
        @segments_order[index]
      else
        nil
      end
    end

    def duplicate_defenition
      if scheme_defined?
        dup_index = @assigning_counter + 1
        @segments_order.insert(dup_index, defenition)
        @segments_order[dup_index][:optional?] = true
        @segments_order[dup_index][:required?] = false
      else
        nil
      end
    end

    def current_scope
      @current_scope
    end

    def begin_scope(scp)
      @scope_stack.push @current_scope
      @current_scope = scp
    end

    def return_scope
      @current_scope = @scope_stack.pop
    end

    def add_children(scope_name)
      begin_scope(scope_name)
      unpacked_childs = unpack(defenition.children, current_scope)
      unpacked_childs.last[:scope_returner] = true
      puts "Add unpacked children #{unpacked_childs}"
      @segments_order += unpacked_childs
    end

    def set_segment(value)
      unless value.nil?
        value.scope = current_scope  
        value.message = self
      end
      @segments[@assigning_counter] = value
    end

    def segments_by_scope(scp = nil)
      find_in_scope = scp || current_scope
      @segments.select {|s| !s.nil? && s.scope == find_in_scope}
    end

    def check_multiple_counter?(cnt)
      if defenition.multiple?
        multiple_counter.to_s == cnt.to_s
      else
        true
      end
    end

    def multiple_counter(seg_name = nil)
      find_name = seg_name || defenition.name
      segments_by_scope.select {|s| s.name == defenition.name}.size
    end

    def real_assign(segment)
      puts "Assigning #{segment.nil? ? 'nil' : segment.name} as #{defenition.inspect}"
      if scheme_defined?
        if segment.nil?
          raise RHL7::InvalidMessage.new("Missing required segment #{defenition.name} in message #{name}")  if defenition.requred?
          set_segment(nil)
        else
          if defenition.name == segment.name
            raise RHL7::InvalidMessage.new("Invalid order of #{segment.name} got: #{segment[1]}, expected: #{multiple_counter} in message #{name}")  unless check_multiple_counter?(segment[1])
            set_segment(segment)

            unless defenition.children.nil?
              new_scope_name = "#{current_scope}_#{segment.name}#{defenition.multiple? ? segment[1] : nil}"
              add_children(new_scope_name)  
            end
            duplicate_defenition  if defenition.multiple?
          else
            real_assign(nil)
            next_segment
            real_assign(segment)
          end
        end

        return_scope  if defenition.scope_returner

      else
        @segments[@assigning_counter] = segment
      end
    end

  end
end