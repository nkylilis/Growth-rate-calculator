function [GFP_rate_max_v, fGFP1,fGFP2,fGFP3] =Normalised_GFP_fluorescence(x1,x2,time_index)


x = xlsread('data', 'GFP');
FI = x(:,2:end);

y = xlsread('data', 'OD700');
OD = y(:,2:end);

time = x(:,1);

%%%%%%%%%%%%%%%%   Green fluorescence over time  %%%%%%%%%%%%%%%%%%%%%%%%%%

FI_media_cor = FI - 125;


%%%%%%%%%%%%%%%%  Normalised GFP fluorescence over time  %%%%%%%%%%%%%%%%%%

OD_media_cor = OD - 0.1;

Norm_fluorescence = FI_media_cor./OD_media_cor;


%%%%%%%%%%%%%%%%%%%%%%  GFP production rate  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[timepoints, wells] = size(Norm_fluorescence);

GFP_rate_samples = zeros(timepoints, wells);

for w = x1:x2
    for t = 2:(timepoints-1)
        GFP_rate = Norm_fluorescence(t+1,w)-Norm_fluorescence(t-1,w);
        GFP_rate_samples(t,w) = GFP_rate/0.66;
    end
end

%%%%%%%%%%%%%%%%  GFP production rate at max growth rate  %%%%%%%%%%%%%%%%%

GFP_rate_max_v = zeros(12,1);
for i = 1:12
    GFP_rate_max = GFP_rate_samples(time_index(i),1);
    GFP_rate_max_v(i,:) = GFP_rate_max;
end

%%%%%%%%%%%%%%%%%%%%%%  Figures  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fGFP1 = figure;
title('Total GFP fluorescence')
for i = 1:12
    subplot(3,4,i)
    plot(time, FI_media_cor(:,i),'.')
    xlabel('time (minutes)')
    ylabel('GFP fluorescence (au)')
    xlim([0 720]);
    ylim([0 6000])
    title('GFP fluorescence over time')
end

fGFP2 = figure;
title('Normalised GFP fluorescence')
b=linspace(0,25000,length(time));
for i = 1:12
    subplot(3,4,i)
    hold on
    plot(time, Norm_fluorescence(:,i),'.')
    plot(time(time_index(i,1)),b,'.r')
    hold off
    xlabel('time (minutes)')
    ylabel('Normalised GFP fluorescence (au)')
    title('Normalised GFP')
    xlim([0 720])
    ylim([0 20000])
end

fGFP3 = figure;
title('GFP production rate')
b=linspace(-1000,6000,length(time));
c=zeros(length(time));
for i = 1:12
    subplot(3,4,i)
    hold on
    plot(time, GFP_rate_samples(:,i),'.');
    plot(time(time_index(i,1)),b,'.r')
    plot(b,c,'m');
    hold off
    xlabel('time (minutes)')
    ylabel('GFP production rate(h-1)')
    title('GFP production rate')
    xlim([0 720]);
    ylim([-1000 6000]);
end