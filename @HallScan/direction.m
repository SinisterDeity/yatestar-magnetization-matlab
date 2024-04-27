function directionString = direction(obj)
%direction Checks whether the mean value of the movement data is >0, with >0 being backwards and <0 being forwards.
if(mean(obj.position(:,2))>=0)
    directionString = "backward";
else
    directionString = "forward";
end

end