function[fval_avg,x_avg]=gen_SSO_average_performance(c_level,epsilon,T,N,M,bb,d_f,p,q,H,fmax,gmin,gmax,w_loc,w_num,error_data,ramp_rate)  
    % scenarios to be generated to meet the probability guarantee
    n_dv=4*N*T;
    Num=ceil(n_dv/(epsilon*c_level))-1;
    % generating wind scenario
    index=ceil(T*Num*(1-epsilon));
    d_real=d_f;
    virtual_bb=bb;

    [gm] = gen_samples(error_data);
    
    for k=1:w_num
        loc=w_loc(k);
%         random_num=zeros(T*Num,1);
%         for i=1:Num
%             rng('default');
%             [random_T,~]=random(gm,T);
%             random_num((i-1)*T+1:i*T)=random_T;
%         end
        rng('default');
        random_num=random(gm,T*Num);
        random_num=sort(random_num);
        virtual_bb(loc)=max([bb(loc)-random_num(index),0]);
    end
            
    [standard_delta,real_bb]= gen_standard_delta(bb,virtual_bb,w_loc);

    umin=-real_bb*ramp_rate;
    umax=real_bb*ramp_rate;  
    [x_avg,fval_avg]=MinC(T,N,M,real_bb,d_real,p,q,H,fmax,gmin,gmax,umin,umax);
end