function adjustedPV = properPV(obj)
%properPV Determines the position-lockin matrix, stitches the data together
tempVolt = obj.lockin;  %Move lockin data to holder variable
for i = 2:obj.numProbes+1
    tempVolt(:,i) = tempVolt(:,i) - obj.Loffsets(i-1);  %Remove offset from data
end
adjustedPV.p = obj.calcPos(obj.lockin(:,1));    %Gets interpolated position
adjustedPV.v = tempVolt(:,2:33);    %Moves offsetted data into structure

end