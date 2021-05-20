function [P_markov]=gen_Binomial_Pmarkov(Gamma,T,epsilon)
    e=1e-5;
    a=0;
    b=1;
    object=1;
    while (abs(object-epsilon)>e)
        x=(a+b)/2;
        object_inverse=0;
        for i=0:1:floor(Gamma)
             object_inverse= object_inverse+nchoosek(T,i).*(x.^i).*((1-x).^(T-i));
        end
        object=1-object_inverse;
        if object<epsilon
            a=x;
        else
            b=x;
        end
    end
    P_markov=x;
end