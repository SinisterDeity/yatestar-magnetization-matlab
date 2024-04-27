classdef HallScan
    %Class for Yatestar Hall Probe Scan
    properties
        position = [];  %nx2 array of time & position data
        lockin = [];    %nx33 array of time & voltage data
        name = "";  %Internal name of measurement
        numProbes = 20;  %# Hall probes used in measurement
        current = 0.001; %Current used for hall probes
        Loffsets = zeros(20,1);  %Hall Probe offsets
    end

    methods
        function obj = HallScan()
            %HALLSCAN Construct an instance of this class
            %   Import data from text file
            obj.name = string(input('Sample Name?\n>','s'));   %Get name of measurement
            [pName,pPath] = uigetfile('*.txt','Choose Position File');  %Get position file
            pFull = string(pPath) + string(pName);  %Make full path for position file
            rawPosition = importdata(pFull);    %Import position data file
            try
            rawPosition = rawPosition.data;
            catch
            end
            rawPosition = rawPosition(rawPosition(:,2) ~=0,:);  %Get rid of any position 0 data points
            [pName,pPath] = uigetfile('*.txt','Choose Lock-In File');   %Get lockin file
            pFull = string(pPath) + string(pName);  %Make full path for lockin file
            rawLockin = importdata(pFull);  %Import lockin file
            try
            rawLockin = rawLockin.data;
            catch
            end
            rawLockin = rawLockin((rawLockin(:,1) > min(rawPosition(:,1))),:);  %Remove lockin points before move
            rawLockin = rawLockin((rawLockin(:,1) < max(rawPosition(:,1))),:);  %Remove lockin points after move
            [~,uniqInd] = unique(rawPosition(:,2),'stable');    %Find unique position indicies
            newT = rawPosition(uniqInd,1);  %Make unique position time array
            newP = rawPosition(uniqInd,2);  %Make unique position array
            rawPosition = [newT,newP];  %Combine uniqued arrays
            [~,uniqInd] = unique(rawPosition(:,1),'stable');    %Find unique position times
            newT = rawPosition(uniqInd,1);  %Make unique position time array
            newP = rawPosition(uniqInd,2);  %Make unique position array
            rawPosition = [newT,newP];  %Combine uniqed arrays
            obj.position = rawPosition; %Load filtered position into class
            obj.lockin = rawLockin; %Load "filtered" lockin data into class
            if(obj.direction == "forward")  %Determing offset
                datIndex = 1;   %datIndex is where to get offset value from
            else    %If its backward
                datIndex = length(obj.lockin);  %Get offset from end
            end
            for i = 2:obj.numProbes+1   %Calculate offsets
                obj.Loffsets(i-1) = mean(rawLockin(datIndex,i));    %Perhaps mean multiple values instead
            end
            z = obj.adjustedVoltages(true); %Show data so judgement on segmentation can be made
            pause(1);   %Needed to avoid hiding figure
            commandwindow;  %Brings focus to command window
            if(string(input('Does this scan need to be segmented? (y or n)\n>','s'))=='y')
                close(z);   %Close preview graph
                obj.segmentScan;    %Multiple tapes in scan, needs to be segmented
            elseif(string(input('Does this scan need to be trimmed? (y or n)\n>','s'))=='y')
                close(z);   %Close preview graph
                obj = obj.trim; %Single tape with anomalous data at the ends
                assignin('base','Scan',obj);    %Creates output variable in base workspace
            else
                close(z);   %Closes original graph
                assignin('base','Scan',obj);    %Creates output variable in base workspace
            end
        end
    end
end