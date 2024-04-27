function z = PaulPlot(obj,absoluteValue)

%PaulPlot Creates a colormap via interpolation between the hall probe signals, named after Xinbo Hu.
hallCoeff = ones(1,obj.numProbes)/1000;   %Hall coefficients [V/T]
hallCoeff=hallCoeff*obj.current;    %Multiplies coefficients by the current used
holder = obj.properPV;  %Gets the position vs lockin matrix
holder.v = holder.v(:,1:obj.numProbes); %Gets rid of lockin voltages not used for scan
holder.v = holder.v./hallCoeff(1:obj.numProbes);    %Converts voltage to magnetic field
[X,Y]=meshgrid(linspace(0,4,obj.numProbes),holder.p);   %Creates mesh to interpolate between
z = figure('Name','Paul Plot of Yatestar Scan');    %Figure name
movegui('center');  %Moves plot to center of screen
hold on;    %Graph holding to modify various things
title('Yatestar Hall Probe Interpolation'); %Figure title
colormap jet;   %Not really sure...determines color profile for interpolation?
if (nargin > 1)
    if(absoluteValue == 1)
        surfc(Y/1000,X,medfilt1(abs(holder.v),50),'EdgeColor','interp','FaceColor','interp');   %Creates colormap
    end
else
    surfc(Y/1000,X,medfilt1(holder.v,50),'EdgeColor','interp','FaceColor','interp');   %Creates colormap
end
h=colorbar; %Creates reference to colorbar of graph
ylabel(h,'| {\itMagnetic Field} | [T]','FontSize',24);  %Y axis label
xlabel('{\itLength} [m]','FontSize',24);    %X axis label
ylabel('{\itWidth} [mm]','FontSize',24);    %Secondary Y axis label
set(gca,'FontSize',20); %Axes font size
set(gca,'LineWidth',2); %Unsure...
box on; %Unsure...
set(gca,'Layer','Top'); %Brings graph to front?

end