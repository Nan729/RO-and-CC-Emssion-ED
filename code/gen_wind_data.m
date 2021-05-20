function[wind_error]= gen_wind_data(real_capacity_scale,filename)
    %filename='.\data\WindGenTotalLoadYTD_2020.xls';
    input_data= xlsread(filename, 1, 'B25:C52428');
    input_scale=mean(input_data(:,1));
    wind_data=input_data./input_scale*real_capacity_scale;
    wind_error=wind_data(:,2)-wind_data(:,1);
%     error_norm=normalize(error_data,'scale');
%     wind_error=error_norm*ratio;
end