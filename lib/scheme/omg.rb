class RHL7::Scheme
  draw :OMG do

    event :O19 do
      segment :MSH, optional: false, multiple: false
      segment :PID, optional: false, multiple: false
      segment :ORC, optional: true,  multiple: false
      segment :OBR, optional: false, multiple: false
      segment :CTD, optional: true,  multiple: false
    end

  end
end