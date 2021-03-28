function[virtual_bb]= gen_virtual_storage_capacity(bb,epsilon,T,gamma_uniform,error_data,flag)
    % flag=1 , Chance Constraint & Gaussian Assumption
    gamma=gamma_uniform*T;
    [mu,sigma]=normfit(error_data);
    if flag==1
        [mu,sigma]=normfit(error_data);
        delta_Gaussian=gen_Gaussian_delta(mu,sigma,epsilon);
        virtual_bb=bb-2*delta_Gaussian;
    end
    if flag==4
        N=length(error_data);
        u=sum(error_data)/N;
        b=sum(abs(error_data-u))/N;
        delta_Laplace=gen_Laplace_delta(u,b,epsilon,mu,sigma);
        virtual_bb=bb-2*delta_Laplace;
    end

    % empirical absolute mean
    error_Q=prctile(abs(error_data),75);
    error_data_del= find(abs(error_data)>error_Q);
    error_data_modified=error_data;
    error_data_modified(error_data_del)=[];
    sample_num=size(error_data_modified ,1);
    empirical_abosulte_mean=sum(abs(error_data_modified ))./sample_num;
    M=empirical_abosulte_mean;
    
    % flag=2. DRO formulation 1: Azuma
    if flag==2
        abc=-T*log(epsilon)/2;
        def=gamma-sqrt(abc);
        space_azuma=M*T./def;
        virtual_bb=bb-2*space_azuma;
    end
    % flag=3, DRO formulation 2: Bernolli
    if flag==3
        P_markov=gen_Binomial_Pmarkov(gamma,T,epsilon);
        Delta_markov=M./P_markov;
        virtual_bb=bb-2*Delta_markov;
    end
end