function [delta]=gen_Laplace_delta(u,bp,epsilon,mu,sigma)
    
    e=1e-3;
    % assume the delta takes value in mu+4sigma , mu-4sigma
    a=0;
    b=abs(mu-4*sigma);
    object=1;
    while (abs(object-epsilon)>e)
        x=(a+b)/2;
        object_left=0.5*exp(-(u-(-x))/bp);
        object_right=1-0.5*exp(-(x-u)/bp);
        object=(1-object_right)+object_left;
        if object>epsilon
            a=x;
        else
            b=x;
        end
    end
    delta=x;
end