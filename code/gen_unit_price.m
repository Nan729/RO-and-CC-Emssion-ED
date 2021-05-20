function [p,q]=gen_unit_price(g_type,carbon_tax)
    N=size(g_type,1);
    % heat rate data
    % coal : 10,481 Btu/kWh, 10.481 MMBtu/MWh, 
    % gas: 7,821 Btu/kWh, 7.821 MMBtu/MWh, 2019,
    % oil: 11,095 Btu/kWh, 10.85 MMBtu/MWh,
    
    % define p_base,q_base, turning points for piese-wise linear
    a=2;
%     b=3;
%     at=200;
%     bt=600;
%     p_1=ones(1,N);
%     p_2=ones(1,N)*a;
%     p_3=ones(1,N)*b;
%     p_base=[p_1;p_2;p_3];
%     q_1=zeros(1,N);
%     q_2=ones(1,N)*(at*(1-a));
%     q_3=ones(1,N)*(b*bt-at-(bt-at)*a);
%     q_base=[q_1;q_2;q_3];
    
    aa=1:0.1:1.5;
    bb_start=50;
    bb_itv=50;
    piece=size(aa,2);
    p_base=aa'*ones(1,N);
    q_base=zeros(piece,N);
    coef=0;
    for k=1:piece-1
        at=bb_start+(k-1)*bb_itv;
        %bt=bb_start+(k)*bb_itv;
        b=aa(k+1);
        a=aa(k);
        coef=a*at+coef-b*at;
        q_base(k+1,:)=ones(1,N)*coef;
    end
    % fuel price and emission
%     	Fuel price ($/MMBTU)	CO2 Emissions production rate (lb/MMBTU)
%         Coal	1.8	203.5
%         Natural gas	5.4	118
%         Oil	21	123.1

    multiplier=zeros(1,N); % buses with no generators will be changed to zero
    for i=1:N
        content=g_type(i,1);
        if contains(cell2mat(content),'Coal')
            fuel_price=1.8;
            CO2_rate=203.5;
            heat_rate=10.481;
            multiplier(1,i)=(fuel_price+CO2_rate*carbon_tax)*heat_rate;
        elseif contains(cell2mat(content),'Gas')
            fuel_price=5.4;
            CO2_rate=118;
            heat_rate=7.821;
            multiplier(1,i)=(fuel_price+CO2_rate*carbon_tax)*heat_rate;     
        elseif contains(cell2mat(content),'Oil')
            fuel_price=21;
            CO2_rate=123.1;
            heat_rate=11.095;   
            multiplier(1,i)=(fuel_price+CO2_rate*carbon_tax)*heat_rate;
        end
    end
    p=p_base.*multiplier;
    q=q_base.*multiplier;
end