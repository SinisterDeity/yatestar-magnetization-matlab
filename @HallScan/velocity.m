function vOut = velocity(obj)
%Determines velocity during the magnetization measurement

h = obj.properPV;  %Get good position values
h.p = rmmissing(h.p);   %Get rid of bad data
h.v = rmmissing(h.v);
vOut = abs(h.p(end) - h.p(1))/(obj.position(end,1)-obj.position(1,1));  %Divide total distance by elapsed time
vOut = vOut/1000;   %Convert to m/s

end

