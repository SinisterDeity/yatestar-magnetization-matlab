function graphRef = adjustedVoltages(obj,desiredDocked)
%plotAdjustedVoltages Creates a plot of the offset voltages in the measurement vs position. Effectively the non-interpolated PaulPlot.
if(nargin==1)
    desiredDocked = false;  %Create new window for plot unless specified
end
graphRef = figure('Name','Adjusted Voltages','WindowState','maximized');    %Pass out figure ref to close it elsewhere
if(desiredDocked)
    set(graphRef,'WindowStyle','Docked');   %Create figure in main matlab window if desired
end
hold on;    %Graph hold to modify things
title('Raw Yatestar Scan'); %Figure title
xlabel('Position [m]'); %X axis label
ylabel('Voltage [V]');  %Y axis label
legendHold = strings(obj.numProbes,1);  %Preallocate legend entries to make MATLAB happy
holder = obj.properPV;  %Get position-lockin matrix

for i = 1:obj.numProbes
    plot(holder.p/1000,holder.v(:,i),'Color',Colors(i));    %Plot each channel (in meters)
    legendHold(i) = strcat("CH",num2str(i));    %Create legend entries
end
[~,hObj]=legend(legendHold,'Location','northwest'); %Specify legend location
hL=findobj(hObj,'type','line');  % get the lines, not text
set(hL,'linewidth',3);  %Increase line width in legend to see it easier
hold off;   %Release graph hold
if (nargout == 0)
    clear graphRef; %Don't output to 'ans' variable unless needed
end

end