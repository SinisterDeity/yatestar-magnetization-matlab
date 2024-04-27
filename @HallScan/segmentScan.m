function segmentScan(inputScan)
%segmentScan Splits a scan into multiple segments. This is used when multiple tapes are soldered together and must be seperately analyzed.
graphRef = figure;  %Get figure ref to close at end, displays to make judgement on where to segment
hold on;    %Figure hold on to change various things
set(graphRef,'WindowStyle','Docked');   %Make figure in main MATLAB window to make things easier
for i = 1:inputScan.numProbes
    plot(inputScan.lockin(:,1)-inputScan.lockin(1,1),inputScan.lockin(:,i+1));  %Plot voltage vs time, offsets time for simplificty
end
xlabel('Time [s]');    %X axis label
ylabel('Voltage [V]');  %Y axis label
pause(1);   %Trivial pause required otherwise figure is hidden by input call below
commandwindow;  %Brings focus to 
numSegments = str2double(string(input('How many segments to create? (# of tapes)\n>','s')));    %How many segments to create?
prevLx = 1; %Variable used to remember the last segment endpoint in lockin data
prevPx = 1; %Variable used to remember the last segment endpoint in position data
for i = 1:numSegments-1 %Last segment is trivial, hence, numSegments-1
    holder = inputScan; %Load inital scan into temp variable
    endTime = str2double(string(input(strcat('What is the timestamp of the end of segment #',num2str(i),'? [s]\n>'),'s'))) + inputScan.lockin(1,1);    %Get endtime of segment from user
    lxVal = endTime;    %Store inputted time as lockin x value
    lxVal = find(holder.lockin(:,1)>=lxVal,1);  %Find index of closest lockin timestamp to inputted value
    holder.lockin = holder.lockin(prevLx:lxVal,:);  %Extract segment of lockin data
    prevLx = lxVal; %Stores determined lockin index for next iteration
    pxVal = endTime;    %Store inputted time as position x value
    pxVal = find(holder.position(:,1)>=pxVal,1);    %Find index of closest position timestamp to inputted value
    holder.position = holder.position(prevPx:pxVal,:);  %Extract segment of position data
    prevPx = pxVal; %Store determined position index for next iteration
    if(string(input(strcat('Does segment #',num2str(i),' need to be trimmed? (y or n)\n>'),'s'))=='y')  %Does this segment need to be trimmed?
        holder = holder.trim;   %Trim segment
    end
    segments(i) = holder; %#ok<AGROW>
    %Loads holder variable into output
end
%{
The next 9 lines are a repeat of the lines above solely for the last
segment, there is probably a more elegent way to do this, but i cannot be
bothered to think about it =D
%}
holder = inputScan;
lxVal = length(holder.lockin(:,1));
holder.lockin = holder.lockin(prevLx:lxVal,:);
pxVal = length(holder.position(:,1));
holder.position = holder.position(prevPx:pxVal,:);
if(string(input(strcat('Does segment #',num2str(i+1),' need to be trimmed? (y or n)\n>'),'s'))=='y')
    holder = holder.trim;
end
segments(i+1) = holder;
try
    holder = evalin('base','segmented');
    if(holder~=[])
        disp('ruh roh shaggy');
    end
catch
    assignin('base','segmented',segments);  %Makes a variable in base workspace which are the segments, probably dangerous to do this way
end
close(graphRef);    %Close graph when done

end