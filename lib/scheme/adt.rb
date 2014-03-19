class RHL7::Scheme
  draw :ADT do

    event :A10 do
      segment :MSH, optional: false, multiple: false
      segment :PID, optional: false, multiple: false
      segment :PV1, optional: false, multiple: false
    end
    
  end
end