function OD700_data_row = growth_curves(x1, x2, OD700_data, time)

t = length(time);
OD700_data_row = OD700_data(1:end,x1:x2);

    for i= 1:12
        
        for n=2:t
            
            if OD700_data_row(n,i)<(1.25*OD700_data_row(1,i))
                OD700_data_row(n,i)=(1.25*OD700_data_row(1,i));
            end
            
        end
        
        OD700_data_row(1,i) = OD700_data_row(2,i);
        
        
    end
    
OD700_data_row = OD700_data_row - OD700_data_row(1,1);

OD700_data_row(OD700_data_row<0.01) = 0.01;

a = [time OD700_data_row];

fig = figure;
for i = 1:12
    subplot(3,4,i)
    plot(time, OD700_data_row(:,i),'.')
    xlabel('time (minutes)')
    ylabel('OD700')
    ylim([0 0.5]);
    xlim([0 1500]);
    title('Sample: '  + string(x1+i) )
end
saveas(gcf,char('Growth curves- Samples '  + string(x1) + '-' + string(x2)+'.png'))
close(fig);

xlswrite(char('growth_curves - Samples ' + string(x1) + '-' + string(x2)), a);

end
