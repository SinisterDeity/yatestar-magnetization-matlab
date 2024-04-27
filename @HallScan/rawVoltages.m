function graphRef = rawVoltages(obj)
%plotRawVoltages Creates a plot of the un-offset lockin voltages vs position
graphRef = figure('Name','Raw Voltages','WindowState','maximized');    %Create new maximized figure
hold on;    %Figure hold to modify things
title('Raw Yatestar Scan'); %Figure title
xlabel('Position [m]'); %X axis label
ylabel('Voltage [V]');  %Y axis label
legendHold = strings(obj.numProbes,1);  %Preallocate legend entries
holder = obj.properPV;  %Get position-lockin matrix
for i = 1:obj.numProbes
    plot(holder.p/1000,obj.lockin(:,i+1),'Color',Colors(i));    %Plot each channel
    legendHold(i) = strcat("CH",num2str(i));    %Make legend entries
end
[~,hObj]=legend(legendHold,'Location','northwest'); %Specify legend location
hL=findobj(hObj,'type','line');  % get the lines, not text
set(hL,'linewidth',3);  %Make legend line larger to see colors easier
hold off;   %Release graph hold
if (nargout==0)
    clear graphRef; %Don't output to 'ans' variable unless needed
end

end