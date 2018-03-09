% matrices that include experimental data
time = xlsread('20180302 raw data','OD700','A1:A70');
OD700_data = xlsread('20180302 raw data','OD700','B1:CS70');
GFP_data = xlsread('20180302 raw data','GFP','B1:CS70');
RFP_data = xlsread('20180302 raw data','RFP','B1:CS70');
timestep = 0.33;    % time difference(in hrs) difference between successive measurements
timestep_min = 20;  % time difference(in minutes) difference between successive measurements


% matrix initialisation that will contain the experimental results
growth_rate_matrix = zeros(8,12); 
GFP_capacity_matrix = zeros(8,12);

% loop iterates through rows A-H of the 96-well microplate to analyse data
i = 1;
x1 = 1;         %well A1
x2 = 12;        %well A12
for i = 1:8
    
    % analysis of cell growth
    OD700_data_row = growth_curves(x1, x2, OD700_data, time);
    [OD_at_maxGR, max_gr, index] = growth_rate(time, OD700_data_row, x1, x2, timestep);
    matrixGR(i,:) = max_gr;
    matrixOD(i,:) = OD_at_maxGR;  
    
    % analysis of GFP fluorescence
    [GFP_per_cell_max_gr, GFP_per_cell_values] = GFP_per_cell(GFP_data, x1, x2, index, OD700_data_row, time, timestep_min);
    matrixGFP(i,:) = GFP_per_cell_max_gr;
    rate_matrix_GFP = GFP_production_rate_per_cell(time, GFP_per_cell_values, timestep, x1, x2, index, timestep_min);
       
    
    % analysis of red fluorescence
    [RFP_per_cell_max_gr, RFP_per_cell_values] = RFP_per_cell(RFP_data, x1, x2, index, OD700_data_row, time, timestep_min);
    matrixRFP(i,:) = RFP_per_cell_max_gr;
    rate_matrix_RFP = RFP_production_rate_per_cell(time, RFP_per_cell_values, timestep, x1, x2, index, timestep_min);
       
    
    x1 = x1 + 12;
    x2 = x2 + 12;
    
    i = i+1;
    
end

%GFP prod rate i.e. @ steady state GFP prod rate = diltuion = growth rate(lambda)*[GFP]
GR_GFP_product_rate = matrixGR.*matrixGFP;

capacity_red = zeros(8,12);

%reduction in cellular capacity as a % and yield
for i = 1:12
    for j = 1:8
    capacity_red(j,i) = GR_GFP_product_rate(j,i)./GR_GFP_product_rate(j,2); %all constructs divided by control with no plasmid
    end
end
%theoretical yield of RFP*number of cells
yield = matrixOD.*matrixRFP;

xlswrite('results', capacity_red, 'Capacity_reduction');
xlswrite('results', GR_GFP_product_rate, 'Growth_rate_GFP_percell_product');
xlswrite('results', matrixGR,'max_growth_rate_analysis');
xlswrite('results', matrixGFP,'GFP_per_cell_@maxGR');
xlswrite('results', matrixRFP,'RFP_per_cell_@maxGR');
xlswrite('results', yield,'yield of recominant protein');
