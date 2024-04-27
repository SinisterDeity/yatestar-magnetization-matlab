function graphRef = basicFourier(obj)
%Plots the fourier transform of a given hall probe

graphRef = figure;  %Create graph
hold on;    %More modifications to this graph will occur
title('Fourier Transform of Yatestar Hall Probe Voltages','FontSize',24);  %Title
xlabel('f [Hz]','FontSize',24);   %X-axis
ylabel('|P1(f)|','FontSize',24);  %Y-axis
L = length(obj.lockin(:,1));    %Length of signal
T = (obj.lockin(end,1) - obj.lockin(1,1))/(1000*L);  %Sampling period
Fs = 1/T;   %Sampling frequency, just the inverse of the period
for i = 1:obj.numProbes %Iterate across all hall probes
    X = obj.lockin(:,i+1);   %Select probe of interest
    if(mod(L,2)~=0) %Signal length L must be even
        L = L - 1;
        X = X(1:end-1);
    end
    Y = fft(X); %Compute fourier transform of signal
    P2 = abs(Y/L);  %Scale signal by length and represent as magnitude
    P1 = P2(1:L/2+1);   %Not really sure
    P1(2:end-1) = 2*P1(2:end-1);    %Not really sure
    f = Fs*(0:(L/2))/L; %Not really sure
    plot(f,P1,'DisplayName',strcat('HP',num2str(i)),'LineWidth',2); %Plot fourier transform
end
legend;

end

