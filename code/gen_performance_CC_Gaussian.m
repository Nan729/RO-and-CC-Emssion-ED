function [x,fval]=gen_performance_CC_Gaussian(T,N,M,bb,d_f,p,q,H,fmax,gmin,gmax,ramp_rate,epsilon,gamma,error_data,w_loc,w_num)
    virtual_bb=[bb bb bb];
    real_bb=zeros(N,1);
    if sum(bb)~=0
        for flag=1:1
            for k=1:w_num
                i=w_loc(k);
                virtual_bb(i,flag)= gen_virtual_storage_capacity(bb(i),epsilon,T,gamma,error_data,flag);
            end
            [standard_delta,real_bb(:,flag)]= gen_standard_delta(bb,virtual_bb(:,flag),w_loc);
        end
    end
    x=zeros(T*N*4,1);
    fval=zeros(1,1);

    for flag=1:1
        umin=-ramp_rate*real_bb(:,flag);
        umax=ramp_rate*real_bb(:,flag);
        [x(:,flag),fval(:,flag)]=MinC(T,N,M,real_bb(:,flag),d_f,p,q,H,fmax,gmin,gmax,umin,umax);
    end
end