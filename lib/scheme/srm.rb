class RHL7::Scheme
  draw :SRM do

    event :S01 do
      segment :MSH, optional: false, multiple: false
      segment :ARQ, optional: false, multiple: false
      segment :APR, optional: true,  multiple: false
      segment :PID, optional: false, multiple: true
      segment :RGS, optional: false, multiple: true do
        segment :AIS, optional: true,  multiple: false
        segment :AIP, optional: true,  multiple: false
        segment :APR, optional: true,  multiple: false
      end
    end

  end
end