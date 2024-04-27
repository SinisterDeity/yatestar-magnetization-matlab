function h = powerSpec(obj)
%Periodogram Power Spectral Density Estimate for all Hall Probes

h = figure;
L = length(obj.lockin(:,1));    %Length of signal
T = (obj.lockin(end,1) - obj.lockin(1,1))/(L);  %Sampling period
Fs = 1/T;   %Sampling frequency, just the inverse of the period
for i = 1:obj.numProbes
    [p,f] = pspectrum(obj.lockin(:,i+1),Fs); %Plot periodogram
    f = (1./f) .* obj.velocity;
    semilogx(f,(10*log10(p)),'LineWidth',2,'DisplayName',strcat('HP',num2str(i)));
    if i == 1
        hold on;
    end
end
legend('FontSize',15,'Location','northwest'); %Add legend
xlabel('Position [m]','FontSize',15);
ylabel('Power Spectrum [dB]','FontSize',15);
title('Power Spectrum of Yatestar Hall Probes','FontSize',15);
hold off;   %Let go of graph