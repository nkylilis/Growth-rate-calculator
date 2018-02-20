function [max_growth_rates, index] = growth_rate(time, OD700, x1, x2, timestep)

ln_OD700 = log(OD700);

time_gr = time(3:end-2);
k = zeros(length(time_gr),12);

for g = 1:12                          
    
    v = zeros(1,length(time_gr));
    
    for i = 2:length(time_gr)
        A = [ln_OD700(i+2,g)  ln_OD700(i+3,g) ln_OD700(i+4,g)];
        B = [ln_OD700(i,g) ln_OD700(i+1,g) ln_OD700(i+2,g)];
        y = mean(A) - mean(B);
        growth_r = y/(2*timestep);
        v(1,i)=growth_r;
    end
    k(:,g) = v;
    
end
c=zeros(2,12);
k = [c; k; c];
fig = figure;
for i = 1:12
    subplot(3,4,i)
    plot(time, k(:,i),'.')
    xlabel('time (minutes)')
    ylabel('growth rate(h-1)')
    ylim([0 2]);
    xlim([0 1500]);
    title('Sample: '  + string(x1+i) )
end
saveas(fig, 'Growth rate- Samples: '  + string(x1) + '-' + string(x2))
close(fig);

xlswrite('growth_rate_analysis - Samples: ' + string(x1) + '-' + string(x2), k);

[max_growth_rates, index] = max(k,[],1);

end
