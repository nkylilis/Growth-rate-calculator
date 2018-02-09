function [max_growth_rates, index, max_dt, f1, f2, f3] = growth_rate4(x1, x2)

x = xlsread('data', 'OD700');

%%%%%%%%%%%%%%%%%%%%     Growth curves %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time = x(:,1);
OD700 = x(:, 2:end);
[timepoints, samples] = size(OD700);

for i= (x1+1):x2
    for n=1:timepoints
        if OD700(n,i)<(1.25*OD700(1,x1))
            OD700(n,i)=(1.25*OD700(1,x1));
        end     
    end
end


cor_OD700 = OD700-0.1;
ln_y = log(cor_OD700);

%%%%%%%%%%%%%%%%%%%     Growth rate curves %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_gr = time(3:end-2);

k = zeros(12,length(time_gr));
j=0;
for g = x1:x2                          %g = 25:36
    
    v = zeros(1,length(time_gr));
    
    for i = 1:length(time_gr)
        A = [ln_y(i+2,g)  ln_y(i+3,g) ln_y(i+4,g)];
        B = [ln_y(i,g) ln_y(i+1,g) ln_y(i+2,g)];
        y = mean(A) - mean(B);
        growth_r = y/0.666;
        v(1,i)=growth_r;
    end
    j=j+1;
    k(j,:) = v;
end
c=zeros(12,2);
k = [c k c]; 
%%%%%%%%%%%%%%%%%%%     Growth rate calculations    %%%%%%%%%%%%%%%%%%%%%%%

[max_growth_rates, index] = max(k,[],2);

max_dt = (log(2)./max_growth_rates)*60;


%%%%%%%%%%%%%%%%%%%%  Figures    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f1=figure;
title('Growth curves')
p =0;
for i = x1:x2 
    p = p+1;
    subplot(3, 4, p);
    plot(time, OD700(:,i),'.');
    xlabel('Time (minutes)');
    ylabel('OD700');
    xlim([0 720]);
    ylim([0 0.4]);
    title('Growth curve');
    
end

f2 =figure;
title('ln(Growth curves)')
p =0;
for i = x1:x2 
    p = p+1;
    subplot(3, 4, p);
    plot(time, ln_y(:,i),'.');
    xlabel('Time (minutes)');
    ylabel('ln(OD700)');
    xlim([0 720]);
    ylim([-6 -1]);
    title('Growth curve');
    
end

f3 = figure;
title('Growth rate')
p =0;
b=linspace(0,1,length(time));
for i = 1:12 
    p = p+1;
    subplot(3, 4, p);
    hold on
    plot(time(index(i,1)),b,'.r')
    plot(time, k(i,:),'.');
    hold off
    xlabel('Time (minutes)');
    ylabel('Growth rate(h-1)');
    xlim([0 720]);
    ylim([0 1]);
    title('Growth rate');
    

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%