function [e_cost, g_cost]=gen_cost_respectively(p_e,q_e,p_g,q_g,G)
    e_cost=0;
    g_cost=0;
    C_e=zeros(size(p_e,1),1);
    C_g=zeros(size(p_e,1),1);
    N=size(G,1);
    T=size(G,2);
    for n=1:N
        for t=1:T
            for i=1:size(p_e,1)
                 C_e(i)=p_e(i,n)*G(n,t)+q_e(i,n);
                 C_g(i)=p_g(i,n)*G(n,t)+q_g(i,n);
            end
            e_cost=e_cost+max(C_e);
            g_cost=g_cost+max(C_g);
        end
    end
end