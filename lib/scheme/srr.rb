class RHL7::Scheme
  draw :SRR do

    event :S01 do
      segment :MSH, optional: false, multiple: false
      segment :MSA, optional: false, multiple: false
      segment :ERR, optional: true,  multiple: true
      segment :SCH, optional: false,  multiple: false do
        segment :TQ1, optional: true,  multiple: true
        segment :NTE, optional: true,  multiple: true
        segment :PID, optional: false, multiple: true
        segment :RGS, optional: false, multiple: true do
          segment :AIS, optional: true,  multiple: false
          segment :AIP, optional: true,  multiple: false
        end
      end
    end

  end
end