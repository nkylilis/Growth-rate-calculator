function [RFP_per_cell_max_gr, RFP_per_cell_values] =RFP_per_cell(RFP_data,x1, x2, index, OD700_data_row, time, timestep_min)

FI = RFP_data(:,x1:x2);
FI_media_cor = FI - FI(1,1);                % corrects for blank fluorescence
FI_media_cor(FI_media_cor<0.011) = 0.01;    % corrects for negative values

RFP_per_cell_values = FI_media_cor./OD700_data_row;
xlswrite(char('GFP_per cell - Samples_'+ string(x1) + '_' + string(x2)), RFP_per_cell_values);

fig = figure;
for i = 1:12
    subplot(3,4,i)
    plot(time, RFP_per_cell_values(:,i),'.')
    xlabel('time (minutes)')
    ylabel('GFP_per cell')
    ylim([0 2.5e4]);
    xlim([0 1500]);
    title('Sample: '  + string(x1+i) )
    vline(index(i)*timestep_min-timestep_min);
end
print('RFP_per cell'  + string(x1) + '-' + string(x2),'-dpng')
close(fig);



for i =1:12
   
    RFP_per_cell_max_gr(1,i) = RFP_per_cell_values(index(i),i);
    
end
