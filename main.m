% switchboard controller
switchboard = [1 1]; % 0/1 =OFF/ON; switchboard=[gfp analysis, rfp analysis] 

% matrices that include experimental data

time = xlsread('OD700_data','Sheet1','A1:A70');
OD700_data = xlsread('OD700_data','Sheet1','B1:CS70');
if switchboard(1) == 1
    GFP_data = xlsread('GFP_data','Sheet1','B1:CS70');
end
if switchboard(2) == 1
    RFP_data = xlsread('RFP_data','Sheet1','B1:CS70');
end

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
     
     
    if switchboard(1) == 1
        % analysis of GFP fluorescence
        [GFP_per_cell_max_gr, GFP_per_cell_values] = GFP_per_cell(GFP_data, x1, x2, index, OD700_data_row, time, timestep_min);
        matrixGFP(i,:) = GFP_per_cell_max_gr;
        rate_matrix_GFP = GFP_production_rate_per_cell(time, GFP_per_cell_values, timestep, x1, x2, index, timestep_min);
    end
    
    
    if switchboard(2) == 1
        % analysis of red fluorescence
        [RFP_per_cell_max_gr, RFP_per_cell_values] = GFP_per_cell(RFP_data, x1, x2, index, OD700_data_row, time, timestep_min);
        matrixRFP(i,:) = RFP_per_cell_max_gr;
        rate_matrix_RFP = GFP_production_rate_per_cell(time, RFP_per_cell_values, timestep, x1, x2, index, timestep_min);
    end   
    
    x1 = x1 + 12;
    x2 = x2 + 12;
    
    i = i+1;
    
end

%GFP prod rate i.e. @ steady state GFP prod rate = diltuion = growth rate(lambda)*[GFP]
GR_GFP_expression_rate = matrixGR.*matrixGFP;

capacity_red = zeros(8,12);

%reduction in cellular capacity as a % and yield
for i = 1:12
    for j = 1:8
    capacity_red(j,i) = GR_GFP_expression_rate(j,i)./GR_GFP_expression_rate(j,2); %all constructs divided by control with no plasmid
    end
end


xlswrite('results', matrixGR,'max_growth_rate_analysis');

if switchboard(1) == 1
    xlswrite('results', matrixGFP,'GFP_per_cell_@maxGR');
    xlswrite('results', GR_GFP_expression_rate, 'Growth_rate_GFP_percell_product');
    xlswrite('results', capacity_red, 'Capacity_reduction');
end

if switchboard(2) == 1
    %theoretical yield of RFP*number of cells
    yield = matrixOD.*matrixRFP;

    xlswrite('results', matrixRFP,'RFP_per_cell_@maxGR');
    xlswrite('results', yield,'yield of recominant protein');
end

