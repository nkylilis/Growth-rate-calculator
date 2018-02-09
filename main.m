
x1 = 1;         %well
x2 = 12;        %well

[max_growth_rates, time_index, max_dt, f1, f2, f3] = growth_rate4(x1, x2);

[GFP_rate_max_v, fGFP1,fGFP2,fGFP3] = Normalised_GFP_fluorescence(x1,x2, time_index);

output = [max_growth_rates time_index GFP_rate_max_v]