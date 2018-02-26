function rate_matrix = GFP_production_rate_per_cell(time, GFP_per_cell_values, timestep, x1, x2, index, timestep_min)
    
    rate_matrix = zeros(length(time), 12);
    
    for o = 1:12
    
        rate_column = zeros(length(time), 1);

        for i = 3 : length(time)-1

           t2 = [GFP_per_cell_values(i,o)  GFP_per_cell_values(i-1,o) GFP_per_cell_values(i+1,o)];
           t1 = [GFP_per_cell_values(i-1,o)  GFP_per_cell_values(i-2,o) GFP_per_cell_values(i,o)];
           rate = (mean(t2) - mean(t1))/(2*timestep);

           rate_column(i,1) = rate;

        end
        
        rate_matrix(:, o) = rate_column; 
        
    end
    a = [time rate_matrix];
    xlswrite(char('GFP_production_rate_per_cell - Samples'+ string(x1) + '-' + string(x2)), a);    
    fig = figure;
    for i = 1:12
        subplot(3,4,i)
        plot(time, rate_matrix(:,i),'.')
        xlabel('time (minutes)')
        ylabel('GFP_production_rate')
        %ylim([0 0.5]);
        xlim([0 1500]);
        title('Sample: '  + string(x1+i) )
        vline(index(i)*timestep_min-timestep_min);
    end
    saveas(gcf,char('GFP_production_rate_per_cell - Samples '  + string(x1) + '-' + string(x2)+'.png'))
    close(fig);

end
