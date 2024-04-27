function positionOut = calcPos(obj,lockinTime)
%calcPos Determines the position based upon a timestamp in the lockin file via interpolation.
if(obj.direction == 'backward')  %#ok<BDSCA>
    positionOut = max(abs(obj.position(:,2)/1000))-interp1(obj.position(:,1),obj.position(:,2)/1000,lockinTime);
    %{
    Subtracts determined position from total length, this is done to make
    forward and backward scans consistent. This is a bit confusing as
    position 0 is then the innermost (radially) end of the tape on the
    manufacturer spool.
    %}
else
    positionOut = -1*interp1(obj.position(:,1),obj.position(:,2),lockinTime);
    %{
    If "forward", then take position as is. Negated because of Yatestar
    motor parity convention.
    %}
end

end