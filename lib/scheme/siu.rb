class RHL7::Scheme
  draw :SIU do

    event :S12 do
      segment :MSH, optional: false, multiple: false
      segment :SCH, optional: false, multiple: false do
        segment :TQ1, optional: true,  multiple: true
        segment :NTE, optional: true,  multiple: false
        segment :PID, optional: false, multiple: false
        segment :RGS, optional: false, multiple: true do
          segment :AIS, optional: true,  multiple: false
          segment :AIP, optional: true,  multiple: false
          segment :APR, optional: true,  multiple: false
        end
      end
    end

    event :S13 do
      segment :MSH, optional: false, multiple: false
      segment :SCH, optional: false, multiple: false do
        segment :NTE, optional: true,  multiple: true
        segment :PID, optional: false, multiple: false
        segment :RGS, optional: false, multiple: true do
          segment :AIS, optional: true,  multiple: false
          segment :AIP, optional: true,  multiple: false
        end
      end
    end

    event :S26 do
      segment :MSH, optional: false, multiple: false
      segment :SCH, optional: false, multiple: false
      segment :PID, optional: false, multiple: false
      segment :PV1, optional: true, multiple: false
      segment :PV2, optional: true, multiple: false
    end

  end
end


