function [GFP_per_cell_max_gr, GFP_per_cell_values] =GFP_per_cell(GFP_data,x1, x2, index, OD700_data_row, time)

FI = GFP_data(:,x1:x2);
FI_media_cor = FI - FI(1,1);                % corrects for blank fluorescence
FI_media_cor(FI_media_cor<0.011) = 0.01;    % corrects for negative values

GFP_per_cell_values = FI_media_cor./OD700_data_row;
xlswrite('GFP_per cell - Samples_'+ string(x1) + '_' + string(x2), GFP_per_cell_values);

fig = figure;
for i = 1:12
    subplot(3,4,i)
    plot(time, GFP_per_cell_values(:,i),'.')
    xlabel('time (minutes)')
    ylabel('GFP_per cell')
    %ylim([0 0.5]);
    xlim([0 1500]);
    title('Sample: '  + string(x1+i) )
end
saveas(fig, 'GFP_per cell'  + string(x1) + '-' + string(x2))
close(fig);



for i =1:12
   
    GFP_per_cell_max_gr(1,i) = GFP_per_cell_values(index(i),i);
    
end