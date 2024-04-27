function [outputScan] = trim(inputScan)
%trim Removes an interval of data in the scan. Used when the color scaling is thrown off by anomalous values
graphRef = figure;  %Store figure ref to close later
hold on;    %Hold on to change several things
set(graphRef,'WindowStyle','Docked');   %Plot in main MATLAB window for ease
for i = 1:inputScan.numProbes
    plot(inputScan.lockin(:,1)-inputScan.lockin(1,1),inputScan.lockin(:,i+1));  %Plot voltage vs time
end
xlabel('Time [s]');    %X axis label
ylabel('Voltage [V]');  %Y axis label
pause(1); %This trivial pause must be done otherwise the input call below hides the figure
commandwindow;
numSegments = str2double(string(input('How many segments to trim?\n>','s')));   %How many segments to trim?
holder = inputScan; %Load original scan into holder variable
for i = 1:numSegments
    startTime = str2double(string(input(strcat('What is the timestamp of the beginning of trim interval #',num2str(i),'? [s]\n>'),'s'))) + inputScan.lockin(1,1);  %Get beginning timestamp
    startIndex = find(holder.lockin(:,1)>=startTime,1); %Find lockin time index closest to input
    endhold = string(input(strcat('What is the timestamp of the end of trim interval #',num2str(i),'? [s] (Type "end" for end of scan)\n>'),'s')); %Get the end of trim
    %MATLAB HATES when you use end, even as a string
    if(endhold == 'end') %#ok<BDSCA>
        endIndex = length(holder.lockin(:,1));  %If end is inputted, use the last element
    else
        endTime = str2double(endhold) + inputScan.lockin(1,1);  %If not end, unoffset time
        endIndex = find(holder.lockin(:,1)>=endTime,1); %Find closest index to inputted time
    end
    holder.lockin(startIndex:endIndex,:) = [];  %Delete determined section
    startIndex = find(holder.position(:,1)>=startTime,1);   %Find closest position time index to input
    %MATLAB hates when you use 'end'
    if(endhold == 'end') %#ok<BDSCA>
        endIndex = length(holder.position(:,1));    %Used last element if 'end' is input
    else
        endTime = str2double(endhold) + inputScan.lockin(1,1);  %If not end, unoffset time
        endIndex = find(holder.position(:,1)>=endTime,1);   %Find closest position time index to input
    end
    holder.position(startIndex:endIndex,:) = [];    %Delete determined interval
end
outputScan = holder;    %Load temp variable into output
close(graphRef);    %Close graph when done

end