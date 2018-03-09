function [OD_at_maxGR, max_growth_rates, index] = growth_rate(time, OD700_data_row, x1, x2, timestep)

ln_OD700_row = log(OD700_data_row);

time_gr = time(3:end-1);
k = zeros(length(time_gr),12);

for g = 1:12                          
    
    v = zeros(1,length(time_gr));
    
    for i = 3:(length(time)-3)
        A = [ln_OD700_row(i,g)  ln_OD700_row(i-1,g) ln_OD700_row(i+1,g)];
        B = [ln_OD700_row(i-1,g) ln_OD700_row(i-2,g) ln_OD700_row(i,g)];
        y = mean(A) - mean(B);
        growth_r = y/(2*timestep);
        v(1,i)=growth_r;
    end
    k(:,g) = v;
    
end
c=zeros(1,12);
k = [c; c; k; c];
fig = figure;set(fig, 'Visible', 'off');
for i = 1:12
    subplot(3,4,i)
    plot(time, k(:,i),'.')
    xlabel('time (minutes)')
    ylabel('growth rate(h-1)')
    ylim([0 2]);
    xlim([0 1500]);
    title('Sample: '  + string(x1+i) )
end
saveas(gcf,char('Growth rate- Samples '  + string(x1) + '-' + string(x2)+'.png'));


xlswrite(char('growth_rate_analysis - Samples ' + string(x1) + '-' + string(x2)), k);

[max_growth_rates, index] = max(k,[],1);

%finding OD at max GR for yield
for i =1:12
       OD_at_maxGR(1,i) = OD700_data_row(index(i),i);
end 


end
